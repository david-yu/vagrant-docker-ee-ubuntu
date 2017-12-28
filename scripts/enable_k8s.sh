#!/bin/bash
# https://docs.docker.com/datacenter/ucp/2.2/guides/admin/configure/ucp-configuration-file/#example-configuration-file

export AUTH_TOKEN="$(curl -sk -d "{\"username\":\"$UCP_USERNAME\",\"password\":\"$UCP_PASSWORD\"}" "https://${UCP_IPADDR}/auth/login" | jq -r .auth_token 2>/dev/null)"
curl -sk -X POST -H "Authorization: Bearer ${AUTH_TOKEN}" --header "Content-Type: application/json" --header "Accept: application/json" -d '{"HTTPPort":80,"HTTPSPort":8443,"Arch":"x86_64"}' "https://${UCP_IPADDR}/api/interlock"
