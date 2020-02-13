# service
include_recipe 'ignite_test::default'

# Build an image that takes longer than two minutes
# (the default read_timeout) to build
#

ignite_image 'centos'

# Make sure that the image does not exist, to avoid a cache hit
# while building the ignite image. This can legitimately fail
# if the image does not exist.
execute 'rmi kkeane/image.4' do
  command 'ignite rmi kkeane/image.4:chef'
  ignore_failure true
  action :run
end

directory '/usr/local/src/container4' do
  action :create
end

cookbook_file '/usr/local/src/container4/Dockerfile' do
  source 'Dockerfile_4'
  action :create
end

ignite_image 'timeout test image' do
  repo 'kkeane/image.4'
  read_timeout 3600 # 1 hour
  write_timeout 3600 # 1 hour
  tag 'chef'
  source '/usr/local/src/container4'
  action :build_if_missing
end
