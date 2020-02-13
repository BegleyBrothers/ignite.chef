#########################
# service named 'ignited'
#########################
ignite_service 'ignited' do
  install_method 'binary'
  service_manager 'auto'
  action [:create, :start]
end

ignite_service 'ignited2' do
  install_method 'auto'
  service_manager 'systemd'
  action [:create, :start]
end
