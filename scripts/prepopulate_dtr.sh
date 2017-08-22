#!/bin/bash

DTR_URL=dtr.local
DTR_PASSWORD=$(cat /vagrant/ucp_password)

# create users
createUser() {
	USER_NAME=$1
  FULL_NAME=$2
  curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" \
    --user admin:dockeradmin -d "{
      \"isOrg\": false,
      \"isAdmin\": false,
      \"isActive\": true,
      \"fullName\": \"${FULL_NAME}\",
      \"name\": \"${USER_NAME}\",
      \"password\": \"docker123\"}" \
      "https://${DTR_URL}/enzi/v0/accounts"
}
createUser david 'David Yu'
createUser solomon 'Solomon Hykes'
createUser banjot 'Banjot Chanana'
createUser vivek 'Vivek Saraswat'
createUser chad 'Chad Metcalf'
# create organizations
createOrg() {
	ORG_NAME=$1
	curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" \
    --user admin:dockeradmin -d "{
      \"isOrg\": true,
      \"name\": \"${ORG_NAME}\"}" \
      "https://${DTR_URL}/enzi/v0/accounts"
}
createOrg engineering
createOrg infrastructure

# create repositories
createRepo() {
    REPO_NAME=$1
    ORG_NAME=$2
    curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" \
      --user admin:dockeradmin -d "{
      \"name\": \"${REPO_NAME}\",
      \"shortDescription\": \"\",
      \"longDescription\": \"\",
      \"visibility\": \"public\"}" \
      "https://${DTR_URL}/api/v0/repositories/${ORG_NAME}"
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
git clone https://github.com/yongshin/leroy-jenkins.git
docker build -t leroy-jenkins /home/ubuntu/leroy-jenkins/
# tag images
docker tag mongo ${DTR_URL}/engineering/mongo:latest
docker tag wordpress ${DTR_URL}/engineering/wordpress:latest
docker tag mariadb ${DTR_URL}/engineering/mariadb:latest
docker tag leroy-jenkins ${DTR_URL}/infrastructure/leroy-jenkins:latest
# push signed images
docker login dtr.local -u admin -p ${DTR_PASSWORD}
docker push ${DTR_URL}/engineering/mongo:latest
docker push ${DTR_URL}/engineering/wordpress:latest
docker push ${DTR_URL}/engineering/mariadb:latest
docker push ${DTR_URL}/infrastructure/leroy-jenkins:latest
