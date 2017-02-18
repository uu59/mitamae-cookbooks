include_recipe "../node/default.rb"
include_recipe "../git/default.rb"

node.reverse_merge!({
  "digdag-ui" => {
    "repo" => "/opt/digdag",
    "revision" => "v0.9.5",
  }
})

repo = node["digdag-ui"][:repo]
rev = node["digdag-ui"][:revision]

run_command <<-SH
  set -e
  git clone https://github.com/treasure-data/digdag #{repo}
  cd #{repo}
  git checkout -f #{rev}
  cd ./digdag-ui
  npm i
  npm run build
SH
