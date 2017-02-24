include_recipe "../core/default.rb"
include_recipe "../nginx/default.rb"

case node[:platform]
when "debian", "ubuntu"
  %w(build-essential libpcre3-dev libssl-dev zlib1g-dev).each do |pkg|
    package pkg
  end
end

root =  "/opt/nginx"
directory "#{root}/src"

tarball = "#{node[:nginx][:version]}.tar.gz"
tarball_path = "#{root}/src/#{tarball}"

# https://github.com/k0kubun/mitamae/issues/46
#
# http_request "/opt/nginx/src/#{tarball}" do
#   url "https://nginx.org/download/nginx-1.11.10.tar.gz"
# end
execute "download tarball" do
  command <<-SH
    set -ue
    test -f "#{tarball_path}" || curl -o "#{tarball_path}" https://nginx.org/download/nginx-1.11.10.tar.gz
  SH
end

execute "extract tarball" do
  command <<-SH
    set -ue
    cd /opt/nginx/src
    tar xf #{tarball}
  SH
end

execute "build nginx" do
  prefix = "#{root}/#{node[:nginx][:version]}"
  command <<-SH
    set -uex
    test -d #{prefix} || {
      cd #{root}/src/nginx-#{node[:nginx][:version]}
      ./configure --prefix=#{prefix} #{node[:nginx][:configure]}
      make
      make install
    }
    ln -sfn #{prefix} #{root}/current
  SH
end

template "/lib/systemd/system/nginx.service"

if File.read("/proc/1/cmdline").match(/init/)
  # Not a docker
  service "nginx" do
    action [:enable, :start, :stop, :restart]
    provider :systemd
  end
end

verify <<-SH
  test -d #{root}
  test -d #{root}/#{node[:nginx][:version]}
  test -L #{root}/current
  test -x #{root}/current/sbin/nginx
  #{root}/current/sbin/nginx -t
SH
