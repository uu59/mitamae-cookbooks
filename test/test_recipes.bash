#!/usr/bin/env bash

set -ue

. "$(dirname $BASH_SOURCE[0])/helper.bash"

prepare-image-all
run-mitamae "cookbooks/core/default.rb"
run-mitamae "cookbooks/core/default.rb" -j repo/test/test-attr.json
run-mitamae "cookbooks/node/default.rb"
run-mitamae "cookbooks/node/default.rb" -j repo/test/test-attr.json
run-mitamae "cookbooks/yarn/default.rb"
run-mitamae "cookbooks/git/default.rb"
run-mitamae "cookbooks/digdag-ui/default.rb" -j repo/test/test-attr.json

