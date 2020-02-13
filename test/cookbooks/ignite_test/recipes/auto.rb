################
# Ignite service
################

ignite_service 'default' do
  install_method 'auto'
  service_manager 'auto'
  action [:create, :start]
end

ignite_image 'alpine' do
  action :pull
end

ignite_vm 'an_echo_server' do
  repo 'alpine'
  command 'nc -ll -p 7 -e /bin/cat'
  port '7:7'
  action :run
end
