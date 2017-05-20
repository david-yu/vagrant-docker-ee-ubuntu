export UCP_IPADDR=$(cat /vagrant/ucp-vancouver-node1-ipaddr)
export DTR_URL=https://dtr.local
export DTR_IPADDR=$(cat /vagrant/dtr-vancouver-node1-ipaddr)

curl -k https://${UCP_IPADDR}/ca > ucp-ca.pem
docker run -it --rm docker/dtr:2.2.1 destroy --ucp-insecure-tls
docker run -i --rm docker/dtr restore --ucp-url ${UCP-IPADDR} --ucp-username admin \
  --ucp-password dockeradmin --dtr-external-url ${DTR_URL} --ucp-node dtr-vancouver-node1 \
  --ucp-ca "$(cat ucp-ca.pem)"  < /tmp/backup.tar
