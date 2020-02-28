
# ignite_service 'default'

ignited_installation_binary 'default' do
  uri node['ignite']['uri']
  action :install
end
