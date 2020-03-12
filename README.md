# Ignite: Micro-VM launcher

Install Weaveworks [Ignite](https://ignite.readthedocs.io/en/stable/index.html).

[Ignite](https://ignite.readthedocs.io/en/stable/index.html) is to a
[Firecracker](https://firecracker-microvm.github.io/) micro-VM what
[Docker](https://hub.docker.io), [Podman](https://podman.io) or
[Rkt](http://coreos.com/rkt) are to a container.

|Branch  | CI Status |
|--------|-----------|
| `master` | [![CircleCI](https://circleci.com/gh/BegleyBrothers/chef-ignite/tree/master.svg?style=svg)](https://circleci.com/gh/BegleyBrothers/chef-ignite/tree/master) |
| `develop` | [![CircleCI](https://circleci.com/gh/BegleyBrothers/chef-ignite/tree/develop.svg?style=svg)](https://circleci.com/gh/BegleyBrothers/chef-ignite/tree/develop) |

| :warning: WARNING          |
|:---------------------------|
| :zap: Code in this repository requires cloud provider credentials and, if made available, will cost you money. |

| :exclamation: NOTE         |
|:---------------------------|
| You accept all responsibility for any and all costs incurred by running any code in this repository.  |

## Contents
<!--ts-->
* [Usage](#usage)
  * [Distributions &amp; Releases](#distributions--releases)
* [Development](#development)
  * [Test-Kitchen](#test-kitchen)
  * [CI/CD &amp; End-to-End Integration Tests](#cicd--end-to-end-integration-tests)
  * [CircleCI](#circleci)
* [Further Development Notes](#further-development-notes)
  * [Git &amp; Signing Commit Data](#git--signing-commit-data)
<!--te-->

## Usage

See the integration tests for examples of how to write a recipe using this
library cookbook.
Specifically, the [`recipe/smoke.rb`](./test/cookbooks/ignite_test/recipes/smoke.rb)
in `test/cookbooks/ignite_test` shows how to install:

1. The `ignite` binary.
1. The `ignited` binary.
1. A service that launches `ignited` in daemon mode (service name `ignite-ignited`).
1. Add a micro-VM manifest (1CPU, 1.2GB HDD, 456MB RAM) to
   `/etc/firecracker/manifests`.
   When the file is written, the `ignite-ignited` service launches the micro-VM.

```ruby
# The `ignite_service` create action installs `ignited`
ignite_service 'ignited' do
  action [:create, :start]  # :delete, :restart, :stop
  install_method 'binary'   # 'package' 'tarball' 'none'
  service_manager 'systemd' # 'execute' 'systemd' 'sysvinit' 'upstart'
  uri 'ignt://weaveworks/?file=ignited&version=0.6.3#amd64' # Conforms to URI spec
  ignited_bin '/usr/bin/ignited' # Path (incl. filename) to install `ignited` executable
end

ignite_installation_binary 'default' do
  action :install      # :uninstall
  ignited_bin '/usr/bin/ignite' # Path (incl. filename) to install `ignite` executable
  install_docker true  # false
  keyboard_atkbd 'y'   # 'n'
  serio_i8042 'y'      # 'n'
  uri 'ignt://weaveworks/?file=ignite&version=0.6.3#amd64' # Conforms to URI spec
end

# Not required if you have created the `ignite_service`
ignited_installation_binary 'default' do
  action :install      # :uninstall
  ignited_bin '/usr/bin/ignited' # Path (incl. filename) to install `ignited` executable
  install_docker true  # false
  keyboard_atkbd 'y'   # 'n'
  serio_i8042 'y'      # 'n'
  uri 'ignt://weaveworks/?file=ignited&version=0.6.3#amd64' # Conforms to URI spec
end
```

### Service Managers

The version 1.0 release has been tested with `systemd` service manager.
However, this cookbook library aims to support the following service managers:

| Status             | Service Manager | Releases | Detail           |
|:------------------:|-----------------|----------|------------------|
| :heavy_check_mark: | Systemd         | Any      | Debian/Ubuntu    |
| :o:                | Sysvinit        | Any      | TBC              |
| :o:                | Upstart         | Any      | TBC              |

### Distributions & Releases

The version 1.0 release has been tested on Debian 10 (Buster) and
Ubuntu 18.04 (Bionic Beaver).
However, this cookbook library aims to supports the following distributions:

| Status           | Distribution            | Releases | Detail |
|:----------------:|-------------------------|----------|--------|
| :o:              | Amazon Linux            | Any      | TBC    |
| :o:              | Centos                  | Any      | TBC    |
| :o:              | Scientific Linux        | Any      | TBC    |
| :o:              | Oracle                  | Any      | TBC    |
|:heavy_check_mark:| Debian                  | 10       | Tested (DigitalOcean) |
| :o:              | Fedora                  | Any      | TBC    |
| :o:              | Redhat Enterprise Linux | Any      | TBC    |
|:heavy_check_mark:| Ubuntu                  | 18.04    | Tested (DigitalOcean) |

If you are able to confirm the following test suite completes for any
distribution & release in the table above and for any cloud provider please
make a pull request updating the table above.

| :warning: WARNING          |
|:---------------------------|
| :zap: Code below requires cloud provider credentials and, if made available, will cost you money. |

| :exclamation: NOTE         |
|:---------------------------|
| You accept all responsibility for any and all costs incurred by running the code below.  |

```bash
export DIGITALOCEAN_ACCESS_TOKEN="<your DigitalOcean token>"
export DIGITALOCEAN_SSH_KEY_IDS="<your DigitalOcean SSH key fingerprint>"
chef exec bundle exec kitchen test smoke-<distro>-<release>
```

## Development

Testing is done against cloud providers that support nested virtualization.
Currently [DigitalOcean](https://m.do.co/c/9a152ce8c79e) is the tested cloud
provider.
Pull requests adding other cloud providers to the test suites are welcome.

### Test-Kitchen

Integration (e2e) tests are setup using [Test-Kitchen](https://github.com/test-kitchen/test-kitchen)
and currently run on [DigitalOcean](https://m.do.co/c/9a152ce8c79e).
[InSpec](https://www.inspec.io/) "compliance as code" controls are used to
[verify the integration-test installations are correct](./test/integration/smoke/inspec/assert_functioning_spec.rb):

| :warning: WARNING          |
|:---------------------------|
| :zap: The following code uses your cloud provider credentials and will cost you money...      |

| :exclamation: NOTE         |
|:---------------------------|
| You accept all responsibility for any costs incurred by running any code in this repository.  |

```bash
export DIGITALOCEAN_ACCESS_TOKEN="<your DigitalOcean token>"
export DIGITALOCEAN_SSH_KEY_IDS="<your DigitalOcean SSH key fingerprint>"
CHEF_LICENSE="accept" chef exec bundle check || bundle install --deployment --clean --jobs=1 --retry=3
CHEF_LICENSE="accept" chef exec bundle exec kitchen list
CHEF_LICENSE="accept" chef exec bundle exec kitchen test list
CHEF_LICENSE="accept" chef exec bundle exec kitchen test <suite-name>
CHEF_LICENSE="accept" chef exec bundle exec kitchen test all
```

### CI/CD & End-to-End Integration Tests

The integration (e2e) tests use cloud providers that support nested
virtualization.
Currently only [DigitalOcean](https://m.do.co/c/9a152ce8c79e) is setup.
PR's adding other providers are welcome.
For reasons of cost alone - multiple cloud VM launches on each PR is costly - we
have not configured CirelceCI to run the integration tests on commits nor
on pull requests.

The e2e integration test is the responsibility of the merge approver.
A example e2e integration test suite is:

| :warning: WARNING          |
|:---------------------------|
| :zap: The following code uses your cloud provider credentials and will cost you money.      |

| :exclamation: NOTE         |
|:---------------------------|
| You accept all responsibility for any costs incurred by running any code in this repository.  |

```bash
export DIGITALOCEAN_ACCESS_TOKEN="<your DigitalOcean token>"
export DIGITALOCEAN_SSH_KEY_IDS="<your DigitalOcean SSH key fingerprint>"
chef exec bundle exec kitchen test smoke-ubunut-18
```

To see a full list of test suites `chef exec bundle exec kitchen list`.

### CircleCI

The [CircleCI](https://circleci.com/gh/BegleyBrothers/cookbook-ignite) is setup
to trigger only lint/style guards.
You can run these tests locally:

```bash
chef exec bundle exec rake style_only
```

## Further Development Notes

### Git & Signing Commit Data

IF you wish to follow the upstream (Begley Brothers Inc.) git workflow
(not required):

```bash
git config --local include.path ../.git-config
```

By inspecting `.git-config` you will see this assumes:

* Isolated SSH keys dedicated to Git usage (minimizing the blast radius from
  compromised keys)
* SSH key files named `<git-user@email>` and `<git-user@email>`.pub
* SSH keys located in the Git [XDG Desktop Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) folder.
* GPG signing is delegated to `signify-notes` script in `./scripts`.
* [Signify](https://www.openbsd.org/papers/bsdcan-signify.html) signed commits
  stored as Git notes with the parent commit ID.

Hope that helps?
