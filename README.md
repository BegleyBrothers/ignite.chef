# Ignite: Micro-VM launcher

Install Weaveworks [Ignite](https://ignite.readthedocs.io/en/stable/index.html).

[Ignite](https://ignite.readthedocs.io/en/stable/index.html) is to a VM what
[Docker](https://hub.docker.io), [Podman](https://podman.io) or
[Rkt](http://coreos.com/rkt) are to a container.

[![Coverage Status](https://coveralls.io/repos/github/BegleyBrothers/cookbook-ignite/badge.svg?branch=develop)](https://coveralls.io/github/BegleyBrothers/cookbook-ignite?branch=develop)

## Usage

See the integration test for an example of how to write a recipe using this
library cookbook.  Specifically the `recipe/smoke.rb`:

- `test/cookbooks/ignite_test`

## Development

Testing is done against cloud providers that support nested virtualization.
Currently DigitalOcean is the default

### Git

```bash
git config --local include.path ../.git-config
```

### Test-Kitchen

Test-Kitchen integration tests currently target a cloud provider
[DigitalOcean]():

```bash
source .env
CHEF_LICENSE="accept" chef exec bundle install
CHEF_LICENSE="accept" chef exec bundle exec kitchen list
CHEF_LICENSE="accept" chef exec bundle exec kitchen test all
CHEF_LICENSE="accept" chef exec bundle exec kitchen test <suite-name>
```

### Requirements: Ubuntu

```bash
bundle check --path=vendor/bundle || bundle install --deployment --clean --without production test --jobs=1 --retry=3
bundle exec kitchen test smoke-ubuntu-18
```

## CI/CD

### CircleCI

1. CircleCI config triggers `rake integration:digitalocean[${TESTS[$CIRCLE_NODE_INDEX]}]`
1. Rake task triggers Kitchen run in DigitalOcean droplet
1. Kitchen run triggers Chef-Zero configuration

## Development Notes
