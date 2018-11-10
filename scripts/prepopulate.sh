#!/bin/bash

export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export UCP_USERNAME=$(cat /vagrant/env/ucp_username)
export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)
export UCP_FQDN=ucp.local
export DTR_FQDN=dtr.local
export DTR_PASSWORD=$(cat /vagrant/env/ucp_password)
export AUTH_TOKEN="$(curl -sk -N -d "{\"username\":\"$UCP_USERNAME\",\"password\":\"$UCP_PASSWORD\"}" "https://${UCP_IPADDR}/auth/login" | jq -r .auth_token)"

# create users
createUser() {
	USER_NAME=$1
  FULL_NAME=$2
	curl -k -X POST "https://${UCP_FQDN}/accounts/" -H  "accept: application/json" \
		-H "Authorization: Bearer ${AUTH_TOKEN}" \
		-H "content-type: application/json" -d "{
			\"isOrg\": false,
      \"isAdmin\": false,
      \"isActive\": true,
      \"fullName\": \"${FULL_NAME}\",
      \"name\": \"${USER_NAME}\",
      \"password\": \"docker123\"}"
}
createUser david 'David Yu'
createUser solomon 'Solomon Hykes'
createUser banjot 'Banjot Chanana'
createUser vivek 'Vivek Saraswat'
createUser chad 'Chad Metcalf'

# create organizations
createOrg() {
	ORG_NAME=$1
	curl -k -X POST "https://${UCP_FQDN}/accounts/" -H "accept: application/json" \
		-H "Authorization: Bearer ${AUTH_TOKEN}" -H "content-type: application/json" -d "{
				\"isOrg\": true,
				\"name\": \"${ORG_NAME}\"}"
}
createOrg engineering
createOrg infrastructure

# create repositories
createRepo() {
    REPO_NAME=$1
    ORG_NAME=$2
    curl -k -X POST --header "Content-Type: application/json" --header "Accept: application/json" \
      --user docker:dockeradmin -d "{
      \"name\": \"${REPO_NAME}\",
      \"shortDescription\": \"\",
      \"longDescription\": \"\",
			\"immutableTags\": false,
			\"scanOnPush\": false,
			\"enableManifestLists\": true,
			\"visibility\": \"public\"}" \
      "https://${DTR_FQDN}/api/v0/repositories/${ORG_NAME}"
}
createRepo mongo engineering
createRepo wordpress engineering
createRepo mariadb engineering
createRepo leroy-jenkins infrastructure
# pull images from hub
docker pull mongo
docker pull wordpress
docker pull mariadb
# build custom images
git clone https://github.com/david-yu/leroy-jenkins.git
docker build -t leroy-jenkins /home/vagrant/leroy-jenkins/
# tag images
docker tag mongo ${DTR_FQDN}/engineering/mongo:latest
docker tag wordpress ${DTR_FQDN}/engineering/wordpress:latest
docker tag mariadb ${DTR_FQDN}/engineering/mariadb:latest
docker tag leroy-jenkins ${DTR_FQDN}/infrastructure/leroy-jenkins:latest
# push signed images
docker login dtr.local -u docker -p ${DTR_PASSWORD}
docker push ${DTR_FQDN}/engineering/mongo:latest
docker push ${DTR_FQDN}/engineering/wordpress:latest
docker push ${DTR_FQDN}/engineering/mariadb:latest
docker push ${DTR_FQDN}/infrastructure/leroy-jenkins:latest
