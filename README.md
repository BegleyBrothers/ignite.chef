# Ignite: Micro-VM launcher

Install Weaveworks [Ignite](https://ignite.readthedocs.io/en/stable/index.html).

[Ignite](https://ignite.readthedocs.io/en/stable/index.html) is to a
[Firecracker](https://firecracker-microvm.github.io/) micro-VM what
[Docker](https://hub.docker.io), [Podman](https://podman.io) or
[Rkt](http://coreos.com/rkt) are to a container.

|Branch  | CI Status |
|--------|-----------|
| `master` | [![BegleyBrothers](https://circleci.com/gh/BegleyBrothers/cookbook-ignite/tree/master.svg?style=svg)](https://circleci.com/gh/BegleyBrothers/cookbook-ignite/tree/master) |
| `develop` | [![BegleyBrothers](https://circleci.com/gh/BegleyBrothers/cookbook-ignite/tree/develop.svg?style=svg)](https://circleci.com/gh/BegleyBrothers/cookbook-ignite/tree/develop) |

| :warning: WARNING          |
|:---------------------------|
| :zap: Code in this repository requires cloud provider credentials and, if made available, will cost you money. |

| :exclamation: NOTE         |
|:---------------------------|
| You accept all responsibility for any and all costs incurred by running any code in this repository.  |

## Contents
<!--ts-->
* [Ignite: Micro-VM launcher](#ignite-micro-vm-launcher)
  * [Usage](#usage)
  * [Development](#development)
    * [Test-Kitchen](#test-kitchen)
    * [CI/CD &amp; End-to-End Integration Tests](#cicd--end-to-end-integration-tests)
    * [CircleCI](#circleci)
  * [Further Development Notes](#further-development-notes)
    * [Git &amp; Signed Commit Data](#git--signed-commit-data)
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

The version 1.0 release has only been tested on Ubuntu 18.04 (Bionic Beaver).
However, this cookbook library supports the following distributions:

| Distribution            | Releases | Status |
|-------------------------|----------|--------|
| Amazon Linux            | Any      | TBC    |
| Centos                  | Any      | TBC    |
| Scientific Linux        | Any      | TBC    |
| Oracle                  | Any      | TBC    |
| Debian                  | Any      | TBC    |
| Fedora                  | Any      | TBC    |
| Redhat Enterprise Linux | Any      | TBC    |
| Ubuntu                  | 18.04    | Tested (DigitalOcean) |

If you are able to confirm the following test suite completes for any distro
release in the table above and for any cloud provider please make a pull request
updating the table above.

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

### Git & Signed Commit Data

IF you wish to follow the upstream (Begley Brothers Inc.) git workflow
(not required):

```bash
git config --local include.path ../.git-config
```

By inspecting `.git-config` you will see this assumes:

- Isolated SSH keys dedicated to Git usage (minimizing the blast radius from compromised keys)
- SSH key files named `<git-user@email>` and `<git-user@email>`.pub
- SSH keys located in the Git [XDG Desktop Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) folder.
- [Signify](https://www.openbsd.org/papers/bsdcan-signify.html) signed commits
  stored as Git notes with the parent commit ID.

Name the following script `signify-notes` and place it in your path, say
`${XDG_DATA_HOME}/signify/bin`, then link `${XDG_DATA_HOME}/signify/bin/signify-notes`
to ``${XDG_DATA_HOME}/bin`, which should be in your `${PATH}`:

```bash
XDG_DATA_HOME=~/.local
mkdir -p ${XDG_DATA_HOME}/signify/bin
tee ${XDG_DATA_HOME}/signify/bin/signify-notes > /dev/null <<'EOF'
#!/usr/bin/env bash
# Usage:
# ======
# `signify-notes [GIT COMMAND]` - Git with signify(1) signatures as `git notes`
#
# To see the signature added as `git notes`:
#
#```bash
# $ git log -2 --notes|less
#```
#
# First, you need to set the signing key for the repo.
# Example:
#
#```bash
# git config --local --add commit.gpgsign true
# git config --local --add user.signingKey "${XDG_CONFIG_HOME}/git/$(git config --local --includes --get user.email).sec"
# git config --local --add gpg.program signify-notes
#```
#
# This will use the keys <user.email>.sec and <user.email>.pub which, under the
# XDG Desktop Base Directory Specification, are located under ${XDG_CONFIG_HOME}.
#
# Then you can use
#
#```bash
# signify-notes commit -S
# signify-notes verify-commit (a no-op: you verify commits not Git)
#
# signify-notes tag -s
# signify-notes verify-tag (a no-op: you verify tags not Git)
#```
#
# Debug Git:
#
#```bash
# git config --global trace2.normalTarget /tmp/git.trace2.normal.log
#```

short_date=$(/bin/date +%m%d%y)
log_file="/tmp/signify-notes-${short_date}.log"
exec {BASH_XTRACEFD}>>${log_file}
set -o xtrace

function getkey () {
  key_sec="$(git config --includes --get user.signingKey)";
  if [ ! -f "${key_sec}" ]; then
    key_sec=$1
  fi
  if [ ! -f "${key_sec}" ];
  then
    echo 'signify-notes: no user.signingKey defined!' 1>&2;
    exit 1;
  fi;
  export key_sec;
  export key_sec_name=$(basename "$key_sec")
}

  while :; do
    case "${1}" in
      -bsau)
          # The command invoked when Signify piggybacks on Git GnuPG support:
          #
          # $ <path>/signify-notes --status-fd=2 -bsau ${XDG_CONFIG_HOME}/git/<user@company.com>.sec
          err_sum=0
          getkey
          filename=$(basename "$0")
          msg_file="$(mktemp /tmp/${filename}.commit.msg.$$.XXXXXX)"
          err_sum=$((err_sum+$?))
          sig_file="$(mktemp /tmp/${filename}.commit.sig.$$.XXXXXXX)"
          err_sum=$((err_sum+$?))
          # Git sends the commit message to sign via stdin.
          dd status=none status=noxfer if=/dev/stdin of=${msg_file} &>/dev/null
          err_sum=$((err_sum+$?))
          if command -v signify-openbsd >/dev/null 2>&1
          then
            signify-openbsd -S -e -x "${sig_file}" -s "${key_sec}" -m "${msg_file}"
            err_sum=$((err_sum+$?))
          elif command -v signify >/dev/null 2>&1
          then
            signify -S -e -x "${sig_file}" -s "${key_sec}" -m "${msg_file}"
            err_sum=$((err_sum+$?))
          fi
          if [ ${err_sum} -eq 0 ] && [ -n "$statusfd" ]; then
            git_note_added="$(git notes add --file=${sig_file})"
            printf '\n[GNUPG:] SIG_CREATED ' >/dev/fd/$statusfd
            rm --force ${msg_file}
            rm --force ${sig_file}
            rm --force ${log_file}
            exit 0
          fi
          exit 1
        ;;
      --verify)
        # Verification is a task for humans. Not Git.
        # Verifying the parent note would bake in GnuPG cruft.
        #
        # Lets not do that.
        #
        # But if you wanted to....
        # An example command invoked when Signify piggybacks on current Git GnuPG support:
        #
        # <path>/signify-notes --keyid-format=long --status-fd=1 --verify /tmp/.git_vtag_tmptWyOLU (Incoming signature)
        echo "[GNUPG:] GOODSIG "
        exit 0
        ;;
      --status-fd=*)
        statusfd=${1#--status-fd=}
        shift
        ;;
      --*)
        shift
        ;;
      *)
        exec git -c "gpg.program=$0" "$@"
        ;;
    esac
  done
EOF
```

Hope that helps?
