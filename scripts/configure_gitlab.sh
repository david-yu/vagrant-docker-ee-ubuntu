#!/bin/bash

curl -H "Content-Type:application/json" http://gitlab.local/api/v3/projects?private_token=$token -d "{ \"name\": \"$repo_name\" }"
