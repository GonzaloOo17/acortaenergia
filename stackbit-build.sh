#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5e3044a53c98830012a0049d/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e3044a53c98830012a0049d
curl -s -X POST https://api.stackbit.com/project/5e3044a53c98830012a0049d/webhook/build/ssgbuild > /dev/null
hugo
wait

curl -s -X POST https://api.stackbit.com/project/5e3044a53c98830012a0049d/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
