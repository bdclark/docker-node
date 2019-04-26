#!/bin/bash
set -e

die() {
   [[ -n "$1" ]] && >&2 echo "Error: $1"
   exit 1
}

[[ -n "$REPO" ]] || die "REPO required"
[[ -n "$VERSION" ]] || die "VERSION required"
[[ -n "$DIST" ]] || die "DIST required"

docker build --tag mybuild --build-arg "NODE_VERSION=$VERSION" "$DIST"

node_version=$(docker run --rm --entrypoint=node mybuild --version) || die "unable to determine revision"
node_version="${node_version//v/}"

IFS="." read -ra semver <<< "${node_version}"
node_major_version="${semver[0]}"
node_minor_version="${semver[0]}.${semver[1]}"

docker tag mybuild "${REPO}:${VERSION}-${DIST}"
docker tag mybuild "${REPO}:${node_version}-${DIST}"
docker tag mybuild "${REPO}:${node_major_version}-${DIST}"
docker tag mybuild "${REPO}:${node_minor_version}-${DIST}"
[[ -n "$TAG" ]] && docker tag mybuild "${REPO}:${TAG}"

if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then
  docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
  docker push "$REPO"
else
  echo "skipping docker push, listing images..."
  docker image ls | grep "$REPO"
fi
