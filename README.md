# Ignite: Micro-VM launcher

Install Weaveworks [Ignite](https://ignite.readthedocs.io/en/stable/index.html).

[Ignite](https://ignite.readthedocs.io/en/stable/index.html) is to a VM what [Docker](https://hub.docker.io), [Podman](https://podman.io) or [Rkt](http://coreos.com/rkt) are to a container.

## Development

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