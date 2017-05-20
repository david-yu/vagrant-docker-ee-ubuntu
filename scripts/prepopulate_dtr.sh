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
      "https://${DTR_IPADDR}/enzi/v0/accounts"
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
      "https://${DTR_IPADDR}/enzi/v0/accounts"
}
createOrg engineering
createOrg infrastructure
# import notary private key
notary -d ~/.docker/trust key import /home/ubuntu/ucp-bundle-admin/key.pem
# create repositories
createRepo() {
    REPO_NAME=$1
    ORG_NAME=$2
    NOTARY_ROOT_PASSPHRASE="docker123"
    NOTARY_TARGETS_PASSPHRASE="docker123"
    NOTARY_SNAPSHOT_PASSPHRASE="docker123"
    NOTARY_DELEGATION_PASSPHRASE="docker123"
    NOTARY_OPTS="-s https://${DTR_URL} -d ${HOME}/.docker/trust"
    curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" \
      --user admin:dockeradmin -d "{
      \"name\": \"${REPO_NAME}\",
      \"shortDescription\": \"\",
      \"longDescription\": \"\",
      \"visibility\": \"public\"}" \
      "https://${DTR_IPADDR}/api/v0/repositories/${ORG_NAME}"
    notary -d ~/.docker/trust -s ${DTR_IPADDR} init ${DTR_IPADDR}/${ORG_NAME}/${REPO_NAME}
    notary -d ~/.docker/trust -s ${DTR_IPADDR} key rotate ${DTR_IPADDR}/${ORG_NAME}/${REPO_NAME} snapshot -r
    notary -d ~/.docker/trust publish -s ${DTR_IPADDR} ${DTR_IPADDR}/${ORG_NAME}/${REPO_NAME}
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
docker build -t leroy-jenkins .
# tag images
docker tag mongo ${DTR_IPADDR}/engineering/mongo:latest
docker tag wordpress ${DTR_IPADDR}/engineering/wordpress:latest
docker tag mariadb ${DTR_IPADDR}/engineering/mariadb:latest
docker tag leroy-jenkins ${DTR_IPADDR}/infrastructure/leroy-jenkins:latest
# push signed images
docker push ${DTR_IPADDR}/engineering/mongo:latest
docker push ${DTR_IPADDR}/engineering/wordpress:latest
docker push ${DTR_IPADDR}/engineering/mariadb:latest
docker push ${DTR_IPADDR}/infrastructure/leroy-jenkins:latest
