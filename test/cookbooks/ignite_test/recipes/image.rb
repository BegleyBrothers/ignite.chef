# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

# Two variables, one recipe.
caname = 'ignite_service_default'
caroot = "/ca/#{caname}"

#########################
# :pull_if_missing, :pull
#########################

# default action, default properties
ignite_image 'hello-world'

# non-default name attribute, containing a single quote
ignite_image "Tom's container" do
  repo 'tduffield/testcontainerd'
end

# :pull action specified
ignite_image 'busybox' do
  action :pull
end

# :pull_if_missing
ignite_image 'debian' do
  action :pull_if_missing
end

# specify a tag and read/write timeouts
ignite_image 'alpine' do
  tag '3.1'
  read_timeout 60
  write_timeout 60
end

# host override
ignite_image 'alpine-localhost' do
  repo 'alpine'
  tag '2.7'
  host 'tcp://127.0.0.1:2376'
  tls_verify true
  tls_ca_cert "#{caroot}/ca.pem"
  tls_client_cert "#{caroot}/cert.pem"
  tls_client_key "#{caroot}/key.pem"
end

#########
# :remove
#########

# install something so it can be used to test the :remove action
execute 'pull vbatts/slackware' do
  command 'docker pull vbatts/slackware ; touch /marker_image_slackware'
  creates '/marker_image_slackware'
  action :run
end

ignite_image 'vbatts/slackware' do
  action :remove
end

########
# :save
########

ignite_image 'save hello-world' do
  repo 'hello-world'
  destination '/hello-world.tar'
  not_if { ::File.exist?('/hello-world.tar') }
  action :save
end

########
# :load
########

ignite_image 'cirros' do
  action :pull
  not_if { ::File.exist?('/marker_load_cirros-1') }
end

ignite_image 'save cirros' do
  repo 'cirros'
  destination '/cirros.tar'
  not_if { ::File.exist?('/cirros.tar') }
  action :save
end

ignite_image 'remove cirros' do
  repo 'cirros'
  not_if { ::File.exist?('/marker_load_cirros-1') }
  action :remove
end

ignite_image 'load cirros' do
  source '/cirros.tar'
  not_if { ::File.exist?('/marker_load_cirros-1') }
  action :load
end

file '/marker_load_cirros-1' do
  action :create
end

###########################
# :build
###########################

# Build from a Dockerfile
directory '/usr/local/src/container1' do
  action :create
end

cookbook_file '/usr/local/src/container1/Dockerfile' do
  source 'Dockerfile_1'
  action :create
end

ignite_image 'someara/image-1' do
  tag 'v0.1.0'
  source '/usr/local/src/container1/Dockerfile'
  force true
  not_if { ::File.exist?('/marker_image_image-1') }
  action :build
end

file '/marker_image_image-1' do
  action :create
end

# Build from a directory
directory '/usr/local/src/container2' do
  action :create
end

file '/usr/local/src/container2/foo.txt' do
  content 'Dockerfile_2 contains ADD for this file'
  action :create
end

cookbook_file '/usr/local/src/container2/Dockerfile' do
  source 'Dockerfile_2'
  action :create
end

ignite_image 'someara/image.2' do
  tag 'v0.1.0'
  source '/usr/local/src/container2'
  action :build_if_missing
end

# Build from a tarball
cookbook_file '/usr/local/src/image_3.tar' do
  source 'image_3.tar'
  action :create
end

ignite_image 'image_3' do
  tag 'v0.1.0'
  source '/usr/local/src/image_3.tar'
  action :build_if_missing
end

#########
# :import
#########

ignite_image 'hello-again' do
  tag 'v0.1.0'
  source '/hello-world.tar'
  action :import
end

################
# :tag and :push
################

# public images
ignite_image 'someara/name-w-dashes'
ignite_image 'someara/name.w.dots'

##################
# Private registry
##################

include_recipe 'ignite_test::registry'

ignite_registry 'localhost:5043' do
  username 'testuser'
  password 'testpassword'
  email 'alice@computers.biz'
end

ignite_image 'localhost:5043/someara/name-w-dashes' do
  not_if { ::File.exist?('/marker_image_private_name-w-dashes') }
  action :push
end

file '/marker_image_private_name-w-dashes' do
  action :create
end

ignite_image 'localhost:5043/someara/name.w.dots' do
  not_if { ::File.exist?('/marker_image_private_name.w.dots') }
  action :push
end

ignite_image 'localhost:5043/someara/name.w.dots' do
  not_if { ::File.exist?('/marker_image_private_name.w.dots') }
  tag 'v0.1.0'
  action :push
end

file '/marker_image_private_name.w.dots' do
  action :create
end

# Pull from the public Dockerhub after being authenticated to a
# private one

ignite_image 'fedora' do
  action :pull
end
