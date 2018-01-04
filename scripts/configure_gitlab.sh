#!/bin/bash

# Create Docker Node App project
curl --request POST --header "PRIVATE-TOKEN: 9koXpg98eAheJpvBs5tK" --header "Content-Type:application/json" http://gitlab.local/api/v3/projects "{ \"name\": \"docker-node-app\" }"

# Create Project webhook
curl --request POST --header "PRIVATE-TOKEN: 9koXpg98eAheJpvBs5tK" --header "Content-Type:application/json" https://gitlab.local/projects/:id/hooks "{ \"url\": \"http://jenkins.local\" }"
