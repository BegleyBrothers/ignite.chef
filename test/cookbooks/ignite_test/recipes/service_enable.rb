service 'ignited' do
  action :enable
end

service 'with_attributes' do
  pattern 'ignite*'
  action :enable
end

service 'specifying the identity attribute' do
  service_name 'ignited'
  action :enable
end
