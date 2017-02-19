include_recipe "../node/default.rb"
include_recipe "../git/default.rb"

node.reverse_merge!({
  "digdag-ui" => {
    "root" => "/opt/digdag-ui",
    "revision" => "v0.9.5",
  }
})

root = node["digdag-ui"][:root]
repo = "#{root}/repo"
rev = node["digdag-ui"][:revision]
rev_dir = "#{root}/#{rev}"

directory root

run_command <<-SH
  set -e
  [ -d "#{rev_dir}" ] || {
    [ -d "#{repo}" ] || git clone https://github.com/treasure-data/digdag #{repo}
    cd "#{repo}"
    if ! git rev-list "#{rev}"; then
      git fetch --all --prune --tags
    fi
    rev="$(git rev-list #{rev} | head -n1)"
    git checkout -f $rev

    cd ./digdag-ui
    npm i
    npm run build

    mkdir -p "#{rev_dir}"
    cp -a ./public/* "#{rev_dir}/"
  }
  ln -sfn "#{rev_dir}" #{root}/current
  chown -R #{node[:core][:owner]}:#{node[:core][:group]} "#{rev_dir}"
  chmod -R +r "#{rev_dir}"
SH

verify <<-SH
  test -f "#{rev_dir}/index.html"
  test -L "#{root}/current"
  test "$(readlink -e "#{root}/current")" = "#{rev_dir}"
  test "$(stat -c "%U:%G" "#{rev_dir}")" = "#{node[:core][:owner]}:#{node[:core][:group]}"

  find "#{rev_dir}" | while read file; do
    test "$(stat -c "%U:%G" "$file")" = "#{node[:core][:owner]}:#{node[:core][:group]}"
  done
SH
