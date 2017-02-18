# NOTE: `package "git"` doesn't work :(
# package "git"

run_command <<-SH
  which git || {
    apt-get update && apt-get install -y --no-install-recommends git
  }
SH
