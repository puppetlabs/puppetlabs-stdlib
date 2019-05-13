# stdlib

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Reference](#reference)
6. [Limitations](#limitations)
7. [Development](#development)
8. [Contributors](#contributors)

## Overview

This module provides a standard library of resources for Puppet modules.

## Module Description

 Puppet modules make heavy use of this standard library. The stdlib module adds the following resources to Puppet:

 * Stages
 * Facts
 * Functions
 * Defined types
 * Data types
 * Providers

> *Note:* As of version 3.7, Puppet Enterprise no longer includes the stdlib module. If you're running Puppet Enterprise, you should install the most recent release of stdlib for compatibility with Puppet modules.

## Setup

[Install](https://puppet.com/docs/puppet/latest/modules_installing.html) the stdlib module to add the functions, facts, and resources of this standard library to Puppet.

If you are authoring a module that depends on stdlib, be sure to [specify dependencies](https://puppet.com/docs/puppet/latest/modules_installing.html) in your metadata.json.

## Usage

Most of stdlib's features are automatically loaded by Puppet. To use standardized run stages in Puppet, declare this class in your manifest with `include stdlib`.

When declared, stdlib declares all other classes in the module. The only other class currently included in the module is `stdlib::stages`.

The `stdlib::stages` class declares various run stages for deploying infrastructure, language runtimes, and application layers. The high level stages are (in order):

  * setup
  * main
  * runtime
  * setup_infra
  * deploy_infra
  * setup_app
  * deploy_app
  * deploy

Sample usage:

```puppet
node default {
  include stdlib
  class { java: stage => 'runtime' }
}
```

## Reference

For information on the classes and types, see the [REFERENCE.md](https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/REFERENCE.md).

## Limitations

As of Puppet Enterprise 3.7, the stdlib module is no longer included in PE. PE users should install the most recent release of stdlib for compatibility with Puppet modules.

For an extensive list of supported operating systems, see [metadata.json](https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/metadata.json)

## Development

Puppet modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve. We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things. For more information, see our [module contribution guide](https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/CONTRIBUTING.md).

To report or research a bug with any part of this module, please go to
[http://tickets.puppetlabs.com/browse/MODULES](http://tickets.puppetlabs.com/browse/MODULES).

## Contributors

The list of contributors can be found at: [https://github.com/puppetlabs/puppetlabs-stdlib/graphs/contributors](https://github.com/puppetlabs/puppetlabs-stdlib/graphs/contributors).
