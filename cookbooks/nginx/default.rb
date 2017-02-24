include_recipe "../core/default.rb"

node.reverse_merge!({
  "nginx" => {
    "install" => "source",
    "version" => "1.11.10",
    "configure" => "--with-http_ssl_module --with-http_gzip_static_module --with-http_v2_module  --with-http_realip_module --with-http_auth_request_module --with-http_addition_module --with-debug --with-pcre-jit --with-ipv6",
  }
})

case node[:nginx][:install]
when "source"
  include_recipe "../nginx/source.rb"
when "package"
  include_recipe "../nginx/package.rb"
else
  raise "Unknown install method: #{node[:nginx][:install]}"
end
