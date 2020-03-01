# Ignite Changelog

This file lists changes made in each version of the Ignite cookbook.

## Contents
<!--ts-->
* [Ignite Changelog](#ignite-changelog)
  * [Release: 1.0.0](#release-100)
    * [Added](#added)
    * [Changed](#changed)
    * [Deprecated](#deprecated)
    * [Removed](#removed)
    * [Workarounds](#workarounds)
    * [Fixed](#fixed)
    * [Security](#security)
* [0.1.0 (2020-02-04)](#010-2020-02-04)

<!-- Added by: hedge, at: Sun  1 Mar 16:50:17 AEDT 2020 -->

<!--te-->

## Release: 1.0.0

### Added

New features

- Add warnings about cloud cost responsibilities.
- Add Apache 2.0 License and DCO sign-offs.
- Add Inspec controls for:
  - Kernel modules (loop and br_netfilter)
  - Environment variables
  - Manifest launched micro-VM's
- Add install recipes for `ignite`, `ignited` and service, for platforms:
  - `amazonlinux`
  - `debian`
  - `scientificlinux`
  - `centos`
  - `fedora`
  - `redhat`
  - `ubuntu`
- Add service configuration templates for:
  - `sytemd`
  - `upstart`
  - `sysvinit`
  - `sysconfig`
- Add install Docker option (default: `n`)
- Add install CNI.
- Add ChefSpec unit tests.
- Add Test-Kitchen integration tests.
- Add regression test Issue #542: JSON or YAML manifests?
- Add LeftHook commit hooks.
- Add several code quality gems.
- Add Policyfiles for cookbook and integration tests.
- Add CircleCI build configuration (style/lint tests only).
- Add Git config to support Signfy signed commit data as Git notes.
- Add `signify-notes` script.

### Changed
Changes in existing functionality.

- No released functionality to change.

### Deprecated
Soon-to-be removed features.

- No released features to deprecate.

### Removed
Removed features.

- No released features to remove.

### Workarounds
Features or bugs with work-arounds - to be removed in future releases.
This list is cumulative to ensure nothing gets lost.

- Add mimic docker install even when Docker not used.  Issue #

### Fixed
Bug fixes.

- No release to fix yet.

### Security 
In case of vulnerabilities.

- No security vulnerabilities to fix.

# 0.1.0 (2020-02-04)

Initial release.

- Add files for git-subrepo to treat cookbook as part of this repository.
