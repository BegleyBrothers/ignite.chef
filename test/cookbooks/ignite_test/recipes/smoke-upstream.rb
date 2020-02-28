
#########################
# service named 'default'
#########################

ignite_service 'default' do
  install_method 'binary'
  graph '/var/lib/ignited'
  action [:create, :start]
end

################
# simple process
################

ignite_image 'busybox' do
  host 'unix:///var/run/docker.sock'
end

ignite_vm 'service default echo server' do
  vm_name 'an_echo_server'
  repo 'busybox'
  command 'nc -ll -p 7 -e /bin/cat'
  port '7'
  action :run
end

#####################
# squid forward proxy
#####################

directory '/etc/squid_forward_proxy' do
  recursive true
  owner 'root'
  mode '0755'
  action :create
end

template '/etc/squid_forward_proxy/squid.conf' do
  source 'squid_forward_proxy/squid.conf.erb'
  owner 'root'
  mode '0755'
  notifies :redeploy, 'ignite_vm[squid_forward_proxy]'
  action :create
end

ignite_image 'cbolt/squid' do
  tag 'latest'
  action :pull
end

ignite_vm 'squid_forward_proxy' do
  repo 'cbolt/squid'
  tag 'latest'
  restart_policy 'on-failure'
  kill_after 5
  port '3128:3128'
  command '/usr/sbin/squid -NCd1'
  volumes '/etc/squid_forward_proxy/squid.conf:/etc/squid/squid.conf'
  subscribes :redeploy, 'ignite_image[cbolt/squid]'
  action :run
end

#############
# service one
#############

ignite_service 'one' do
  action :start
end

ignite_image 'hello-world' do
  host 'unix:///var/run/docker-one.sock'
  tag 'latest'
end

ignite_vm 'hello-world' do
  host 'unix:///var/run/docker-one.sock'
  command '/hello'
  action :create
end
