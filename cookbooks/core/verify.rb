define :verify do
  run_command <<-SH
    set -uex
    #{params[:name]}
  SH
end
