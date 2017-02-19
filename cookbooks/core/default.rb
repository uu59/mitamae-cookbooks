node.reverse_merge!({
  "core" => {
    "owner" => "root",
    "group" => "wheel",
  }
})

user = node[:core][:owner]
group = node[:core][:group]

run_command <<-SH
  groupadd #{group}
  id #{user} || useradd -m -g #{group} #{user}
SH

include_recipe "./verify.rb"
