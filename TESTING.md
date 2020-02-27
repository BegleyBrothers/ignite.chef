# Cookbook TESTING doc

This document describes the process for testing using Test-Kitchen.

## Testing Prerequisites

1. Ignite `>=0.6.3`
1. ChefDK `>=14.3`

## Installing dependencies

This Cookbook requires additional testing dependencies that do not ship
with ChefDK directly. These are listed in the `Gemfile` and are installed
into the ChefDK ruby environment with the following commands

Install dependencies:

```shell
chef exec bundle install
```

Update any installed dependencies to the latest versions:

```shell
chef exec bundle update
```

## Lint & Syntax stage

The lint checks run Ruby specific code linting using
[Cookstyle](<https://github.com/chef/cookstyle>).
Cookstyle offers a tailored RuboCop configuration enabling / disabling rules
to better meet the needs of cookbook authors.
Cookstyle ensures that projects with multiple authors have consistent code
styling.

### Unit stage

The unit stage runs unit testing with [InSpec](https://github.com/inspec/kitchen-inspec). 
InSpec is an extension of Rspec, specially formulated for testing Chef cookbooks.

InSpec compiles cookbook code and converges the run in memory, without
actually executing the changes.
The user can write various assertions based on what they expect to have
happened during the Chef run.
InSpec is very fast, and so is useful for testing complex logic as you can
easily converge a cookbook many times in different ways.

## Integration Testing

Integration testing is performed by Test Kitchen - using Cloud VMs.
After a successful converge, InSpec tests are uploaded and ran out of band of Chef.
Tests are be designed to ensure that a recipe has accomplished its goal.

### Kitchen

Integration tests can be performed on a local workstation using either VirtualBox or VMWare as the virtualization hypervisor. To run tests against all available instances run:

```shell
chef exec kitchen test
```

To see a list of available test instances run:

```shell
chef exec kitchen list
```

To test specific instance run:

```shell
chef exec kitchen test INSTANCE_NAME
```
