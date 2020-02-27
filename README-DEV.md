# Ignite: Micro-VM launcher

[![Coverage Status](https://coveralls.io/repos/github/BegleyBrothers/cookbook-ignite/badge.svg?branch=develop)](https://coveralls.io/github/BegleyBrothers/cookbook-ignite?branch=develop)

Install Weaveworks [Ignite](https://ignite.readthedocs.io/en/stable/index.html).

[Ignite](https://ignite.readthedocs.io/en/stable/index.html) is to a VM what [Docker](https://hub.docker.io), [Podman](https://podman.io) or [Rkt](http://coreos.com/rkt) are to a container.

## Usage

Requires [Chef client version](https://docs.chef.io/release_notes.html) `>= 14.3`
- for `sysctl` amd `kernel_module` resources.

For working/tested usage examples, see `./test/cookbooks/ignite_test`.

The `service.rb` recipe is likely most useful in production settings.

## Development

Test-Kitchen integration tests currently target a cloud provider
[DigitalOcean]():

```bash
source .env
CHEF_LICENSE="accept" chef exec bundle install
CHEF_LICENSE="accept" chef exec bundle exec kitchen list
CHEF_LICENSE="accept" chef exec bundle exec kitchen test all
CHEF_LICENSE="accept" chef exec bundle exec kitchen test <suite-name>
```

### NOTE NOTE NOTE

Running Test-Kitchen's Dokken tool-chain within Docker (DinD) is currently
blocked by this issue:
[DinD/CI: Did not find config file: /opt/kitchen/client.rb](https://github.com/someara/kitchen-dokken/issues/149)

A more productive path is likely to be via patching the [kitchen-local]()
Transport gem - to fix this issue.

For useful history/background (note kitchen-Docker is in worse shape wrt this
workflow): [Can You Run ChefDK and Kitchen-Docker inside of a docker container](https://hackernoon.com/can-you-run-chefdk-and-kitchen-docker-inside-of-a-docker-container-10c384571f34)

### Git

```bash
git config --local credential.helper store
git push
```

### Requirements: Ubuntu

```bash
bundle check --path=vendor/bundle || bundle install --deployment --clean --without production test --jobs=1 --retry=3
bundle exec rake integration:dokken[ubuntu]
```

## CI/CD

### CircleCI

1. CircleCI config triggers `rake integration:docker[${TESTS[$CIRCLE_NODE_INDEX]}]`
1. Rake task trigger Kitchen run in dokken
1. Kitchen run trigger Chef-Zero configuration
