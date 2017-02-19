include_recipe "./verify.rb"

node.reverse_merge!({
  "core" => {
    "owner" => "root",
    "group" => "wheel",
  }
})

user = node[:core][:owner]
group = node[:core][:group]

run_command <<-SH
  grep -E "^#{group}:" /etc/group || groupadd #{group}
  id #{user} || useradd -m -g #{group} #{user}
SH

verify <<-SH
  grep -E "^#{group}:" /etc/group
  id "#{user}"
SH
