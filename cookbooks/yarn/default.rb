include_recipe "../node/default.rb"

# https://yarnpkg.com/en/docs/install#linux-tab
case node[:platform]
when "debian", "ubuntu"
  run_command <<-SH
    which yarn || {
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
      apt-get update && apt-get install -y yarn
    }
  SH
else
  raise "Not supported platform (recognized platform: #{node[:platform]})"
end
