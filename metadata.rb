# frozen_string_literal: true
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

name('ignite')
maintainer('Begley Brothers Inc')
maintainer_email('begleybrothers@gmail.com')
license('Apache 2.0')
description('Installs/Configures weaveworks-ignite')
long_description(IO.read(File.join(File.dirname(__FILE__), 'README.md')))
issues_url('https://github.com/begleybrothers/cookbook-ignite/issues')
source_url('https://github.com/begleybrothers/cookbook-ignite')
version('0.5.0')

source_url('https://github.com/chef-cookbooks/docker')
issues_url('https://github.com/chef-cookbooks/docker/issues')

supports('amazon')
supports('centos')
supports('scientific')
supports('oracle')
supports('debian')
supports('fedora')
supports('redhat')
supports('ubuntu')

chef_version('>= 12.15')

depends('audit')
depends('chef-apt-docker')
depends('chef-yum-docker')
depends('docker')
depends('git')
depends('line')

gem('docker-api', '~> 1.34.0')
