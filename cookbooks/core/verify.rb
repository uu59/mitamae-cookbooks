define :verify do
  # /mitamae/repo/cookbooks/core/default.rb:24:in MItamae::Recipe#instance_eval
  # to
  # ./cookbooks/core/default.rb:24
  source = caller.grep(/cookbooks/).first.gsub(/.*?cookbooks/, "./cookbooks").gsub(/:in.*/, "")

  execute "verify from #{source}" do
    action :run
    command <<-SH
      set -uex
      #{params[:name]}
    SH
  end
end
