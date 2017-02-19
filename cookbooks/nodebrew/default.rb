include_recipe "../core/default.rb"

node.reverse_merge!({
  "nodebrew" => {
    "root" => "/opt/nodebrew",
    "version" => "v7",
  }
})

root = node[:nodebrew][:root]
nodebrew = "#{root}/current/bin/nodebrew"
ENV["NODEBREW_ROOT"] = root
ENV["PATH"] += ":#{root}/current/bin"

run_command <<-SH
  mkdir -p "#{root}"
  [ -x "#{nodebrew}" ] || curl -L git.io/nodebrew | perl - setup
SH

define :setup_specific_node_binary do
  ver = params[:name]
  run_command <<-SH
    if ! #{nodebrew} exec "#{ver}" -- node -v; then
      #{nodebrew} install-binary #{ver}
      #{nodebrew} use #{ver}
    fi
  SH
end

setup_specific_node_binary node[:nodebrew][:version]

run_command <<-SH
  chown -R #{node[:core][:owner]}:#{node[:core][:group]} #{root}
SH


verify <<-SH
  which nodebrew
  stat -c "%U:%G" "#{root}"
  node -v | grep -F "#{node[:nodebrew][:version]}"
SH
