
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

# Stop the service then delete ....
ignite_service 'ignited2' do
  action [:stop, :delete]
end

# ... is the same as delete the service alone.
ignite_service 'ignited' do
  action [:delete]
end
