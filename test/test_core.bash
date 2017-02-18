#!/usr/bin/env bash

set -ue

. "$(dirname $BASH_SOURCE[0])/helper.bash"

prepare-image-all
run-mitamae "cookbooks/core/default.rb"
