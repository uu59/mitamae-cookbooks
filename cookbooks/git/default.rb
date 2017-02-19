# NOTE: `package "git"` doesn't work :(
# package "git"

include_recipe "../core/default.rb"

run_command <<-SH
  which git || {
    apt-get update && apt-get install -y --no-install-recommends git
  }
SH

verify <<-SH
  which git
SH
