#!/bin/bash
# designed to be run from a 'docker' folder in a workspace

docker rmi liferay-portal -f &> /dev/null

set -e

cd ..

liferaybuildfile=${PWD##*/}

##./gradlew clean
./gradlew distBundleTar -Pliferay.workspace.environment=$1 -x test --stacktrace
rm -rf build/dist

cd docker
mv ../build/${liferaybuildfile}.tar.gz liferay-docker.tar.gz

docker image build --force-rm -t liferay-portal:latest -f liferay-portal.Dockerfile .
