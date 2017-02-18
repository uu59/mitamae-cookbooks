#!/usr/bin/env bash

set -ue

repodir() {
  echo "$(cd $(dirname $BASH_SOURCE[0])/..; pwd)"
}

prepare-image-all() {
  for file in $(repodir)/Dockerfile*; do
    prepare-image "$file"
  done
}

prepare-image() {
  local file="$1"
  tag="$(image-tag-from-dockerfile "$file")"
  docker build -f "$file" -t "$tag" .
}

image-tag-from-dockerfile() {
  local file="$1"
  echo "mitamae-test-${file##*/Dockerfile-}"
}

cleanup-images() {
  test-images | xargs docker rmi
}

test-images() {
  docker images | grep -o -E 'mitamae-test-[a-z0-9]+'
}

rollback-pwd() {
  cd "$current_pwd"
}


run-mitamae() {
  local target="$1"
  for tag in $(test-images); do
    docker run -v $(repodir):/mitamae/repo "$tag" ./mitamae local -l debug repo/$target
  done
}
