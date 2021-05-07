#!/bin/bash
set -e

base_dir=$(cd "$(dirname "$0")"; pwd)


user=$1
repo=$2

github_repo_url="https://github.com/$user/$repo"
echo "Downloading devfile from $github_repo_url ..."
mkdir -p "$base_dir/../devfiles/$user-$repo"
cd "$base_dir/../devfiles/$user-$repo" && curl -OL https://raw.githubusercontent.com/$user/$repo/master/devfile.yaml
pwd
yq -Y ".projects += [{\"name\": \"$repo\", \"source\": { \"location\": \"https://github.com/$user/$repo\",\"type\": \"github\"}}]" devfile.yaml > /tmp/devfile.yaml && cp /tmp/devfile.yaml . && rm /tmp/devfile.yaml
echo "{}" | yq -Y ". = {\"displayName\": \"$repo\", \"tags\": \"github\", \"globalMemoryLimit\": \"7Gi\", \"icon\": \"https://www.eclipse.org/che/images/logo-eclipseche.svg\" , \"description\": \"Devfile for https://github.com/$user/$repo\", \"links\" : {\"self\" : \"/devfiles/$user-$repo/devfile.yaml\"}}" > meta.yaml