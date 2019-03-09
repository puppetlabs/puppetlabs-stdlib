# stdlib

#### Table of Contents

1. [Overview](#overview)
1. [Module Description](#module-description)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Reference](#reference)
    1. [Data Types](#data-types)
    1. [Facts](#facts)
1. [Limitations](#limitations)
1. [Development](#development)
1. [Contributors](#contributors)

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

<a id="data-types"></a>
### Data types

#### `Stdlib::Absolutepath`

A strict absolute path type. Uses a variant of Unixpath and Windowspath types.

Acceptable input examples:

```shell
/var/log
```

```shell
/usr2/username/bin:/usr/local/bin:/usr/bin:.
```

```shell
C:\\WINDOWS\\System32
```

Unacceptable input example:

```shell
../relative_path
```

#### `Stdlib::Ensure::Service`

Matches acceptable ensure values for service resources.

Acceptable input examples:

```shell
stopped
running
```

Unacceptable input example:

```shell
true
false
```

#### `Stdlib::HTTPSUrl`

Matches HTTPS URLs. It is a case insensitive match.

Acceptable input example:

```shell
https://hello.com

HTTPS://HELLO.COM
```

Unacceptable input example:

```shell
httds://notquiteright.org`
```

#### `Stdlib::HTTPUrl`

Matches both HTTPS and HTTP URLs. It is a case insensitive match.

Acceptable input example:

```shell
https://hello.com

http://hello.com

HTTP://HELLO.COM
```

Unacceptable input example:

```shell
httds://notquiteright.org
```

#### `Stdlib::MAC`

Matches MAC addresses defined in [RFC5342](https://tools.ietf.org/html/rfc5342).

#### `Stdlib::Unixpath`

Matches absolute paths on Unix operating systems.

Acceptable input example:

```shell
/usr2/username/bin:/usr/local/bin:/usr/bin:

/var/tmp
```

Unacceptable input example:

```shell
C:/whatever

some/path

../some/other/path
```

#### `Stdlib::Filemode`

Matches octal file modes consisting of one to four numbers and symbolic file modes.

Acceptable input examples:

```shell
0644
```

```shell
1777
```

```shell
a=Xr,g=w
```

Unacceptable input examples:

```shell
x=r,a=wx
```

```shell
0999
```

#### `Stdlib::Windowspath`

Matches paths on Windows operating systems.

Acceptable input example:

```shell
C:\\WINDOWS\\System32

C:\\

\\\\host\\windows
```

Valid values: A windows filepath.

#### `Stdlib::Filesource`

Matches paths valid values for the source parameter of the Puppet file type.

Acceptable input example:

```shell
http://example.com

https://example.com

file:///hello/bla
```

Valid values: A filepath.

#### `Stdlib::Fqdn`

Matches paths on fully qualified domain name.

Acceptable input example:

```shell
localhost

example.com

www.example.com
```
Valid values: Domain name of a server.

#### `Stdlib::Host`

Matches a valid host which could be a valid ipv4, ipv6 or fqdn.

Acceptable input example:

```shell
localhost

www.example.com

192.0.2.1
```

Valid values: An IP address or domain name.

#### `Stdlib::Port`

Matches a valid TCP/UDP Port number.

Acceptable input examples:

```shell
80

443

65000
```

Valid values: An Integer.

#### `Stdlib::Port::Privileged`

Matches a valid TCP/UDP Privileged port i.e. < 1024.

Acceptable input examples:

```shell
80

443

1023
```

Valid values: A number less than 1024.

#### `Stdlib::Port::Unprivileged`

Matches a valid TCP/UDP Privileged port i.e. >= 1024.

Acceptable input examples:

```shell
1024

1337

65000

```

Valid values: A number more than or equal to 1024.

#### `Stdlib::Base32`

Matches paths a valid base32 string.

Acceptable input example:

```shell
ASDASDDASD3453453

asdasddasd3453453=

ASDASDDASD3453453==
```

Valid values: A base32 string.

#### `Stdlib::Base64`

Matches paths a valid base64 string.

Acceptable input example:

```shell
asdasdASDSADA342386832/746+=

asdasdASDSADA34238683274/6+

asdasdASDSADA3423868327/46+==
```

Valid values: A base64 string.

#### `Stdlib::Ipv4`

This type is no longer available. To make use of this functionality, use [Stdlib::IP::Address::V4](https://github.com/puppetlabs/puppetlabs-stdlib#stdlibipaddressv4).

#### `Stdlib::Ipv6`

This type is no longer available. To make use of this functionality, use  [Stdlib::IP::Address::V6](https://github.com/puppetlabs/puppetlabs-stdlib#stdlibipaddressv6).

#### `Stdlib::Ip_address`

This type is no longer available. To make use of this functionality, use  [Stdlib::IP::Address](https://github.com/puppetlabs/puppetlabs-stdlib#stdlibipaddress)

#### `Stdlib::IP::Address`

Matches any IP address, including both IPv4 and IPv6 addresses. It will match them either with or without an address prefix as used in CIDR format IPv4 addresses.

Examples:

```
'127.0.0.1' =~ Stdlib::IP::Address                                # true
'10.1.240.4/24' =~ Stdlib::IP::Address                            # true
'52.10.10.141' =~ Stdlib::IP::Address                             # true
'192.168.1' =~ Stdlib::IP::Address                                # false
'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210' =~ Stdlib::IP::Address  # true
'FF01:0:0:0:0:0:0:101' =~ Stdlib::IP::Address                     # true
```

#### `Stdlib::IP::Address::V4`

Match any string consisting of an IPv4 address in the quad-dotted decimal format, with or without a CIDR prefix. It will not match any abbreviated form (for example, 192.168.1) because these are poorly documented and inconsistently supported.

Examples:

```
'127.0.0.1' =~ Stdlib::IP::Address::V4                                # true
'10.1.240.4/24' =~ Stdlib::IP::Address::V4                            # true
'192.168.1' =~ Stdlib::IP::Address::V4                                # false
'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210' =~ Stdlib::IP::Address::V4  # false
'12AB::CD30:192.168.0.1' =~ Stdlib::IP::Address::V4                   # false
```

Valid values: An IPv4 address.

#### `Stdlib::IP::Address::V6`

Match any string consistenting of an IPv6 address in any of the documented formats in RFC 2373, with or without an address prefix.

Examples:

```
'127.0.0.1' =~ Stdlib::IP::Address::V6                                # false
'10.1.240.4/24' =~ Stdlib::IP::Address::V6                            # false
'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210' =~ Stdlib::IP::Address::V6  # true
'FF01:0:0:0:0:0:0:101' =~ Stdlib::IP::Address::V6                     # true
'FF01::101' =~ Stdlib::IP::Address::V6                                # true
```

Valid values: An IPv6 address.

#### `Stdlib::IP::Address::Nosubnet`

Match the same things as the `Stdlib::IP::Address` alias, except it will not match an address that includes an address prefix (for example, it will match '192.168.0.6' but not '192.168.0.6/24').

Valid values: An IP address with no subnet.

#### `Stdlib::IP::Address::V4::CIDR`

Match an IPv4 address in the CIDR format. It will only match if the address contains an address prefix (for example, it will match '192.168.0.6/24'
but not '192.168.0.6').

Valid values: An IPv4 address with a CIDR provided eg: '192.186.8.101/105'. This will match anything inclusive of '192.186.8.101' to '192.168.8.105'.

#### `Stdlib::IP::Address::V4::Nosubnet`

Match an IPv4 address only if the address does not contain an address prefix (for example, it will match '192.168.0.6' but not '192.168.0.6/24').

Valid values: An IPv4 address with no subnet.

#### `Stdlib::IP::Address::V6::Full`

Match an IPv6 address formatted in the "preferred form" as documented in section 2.2 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt), with or without an address prefix as documented in section 2.3 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt).

#### `Stdlib::IP::Address::V6::Alternate`

Match an IPv6 address formatted in the "alternative form" allowing for representing the last two 16-bit pieces of the address with a quad-dotted decimal, as documented in section 2.2.1 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt). It will match addresses with or without an address prefix as documented in section 2.3 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt).

#### `Stdlib::IP::Address::V6::Compressed`

Match an IPv6 address which may contain `::` used to compress zeros as documented in section 2.2.2 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt). It will match addresses with or without an address prefix as documented in section 2.3 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt).

#### `Stdlib::IP::Address::V6::Nosubnet`

Alias to allow `Stdlib::IP::Address::V6::Nosubnet::Full`, `Stdlib::IP::Address::V6::Nosubnet::Alternate` and `Stdlib::IP::Address::V6::Nosubnet::Compressed`.

#### `Stdlib::IP::Address::V6::Nosubnet::Full`

Match an IPv6 address formatted in the "preferred form" as documented in section 2.2 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt). It will not match addresses with address prefix as documented in section 2.3 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt).

#### `Stdlib::IP::Address::V6::Nosubnet::Alternate`

Match an IPv6 address formatted in the "alternative form" allowing for representing the last two 16-bit pieces of the address with a quad-dotted decimal, as documented in section 2.2.1 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt). It will only match addresses without an address prefix as documented in section 2.3 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt).

#### `Stdlib::IP::Address::V6::Nosubnet::Compressed`

Match an IPv6 address which may contain `::` used to compress zeros as documented in section 2.2.2 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt). It will only match addresses without an address prefix as documented in section 2.3 of [RFC 2373](https://www.ietf.org/rfc/rfc2373.txt).

#### `Stdlib::IP::Address::V6::CIDR`

Match an IPv6 address in the CIDR format. It will only match if the address contains an address prefix (for example, it will match   'FF01:0:0:0:0:0:0:101/32', 'FF01::101/60', '::/0',
but not 'FF01:0:0:0:0:0:0:101', 'FF01::101', '::').

#### `Stdlib::ObjectStore`

Matches cloud object store uris.

Acceptable input example:

```shell
s3://mybucket/path/to/file

gs://bucket/file

```
Valid values: cloud object store uris.


#### `Stdlib::ObjectStore::GSUri`

Matches Google Cloud object store uris.

Acceptable input example:

```shell

gs://bucket/file

gs://bucket/path/to/file

```
Valid values: Google Cloud object store uris.


#### `Stdlib::ObjectStore::S3Uri`

Matches Amazon Web Services S3 object store uris.

Acceptable input example:

```shell
s3://bucket/file

s3://bucket/path/to/file

```
Valid values: Amazon Web Services S3 object store uris.

#### `Stdlib::Syslogfacility`

An enum that defines all syslog facilities defined in [RFC5424](https://tools.ietf.org/html/rfc5424). This is based on work in the [voxpupuli/nrpe](https://github.com/voxpupuli/puppet-nrpe/commit/5700fd4f5bfc3e237195c8833039f9ed1045cd6b) module.

<a id="facts"></a>
### Facts

#### `package_provider`

Returns the default provider Puppet uses to manage packages on this system.

#### `is_pe`

Returns whether Puppet Enterprise is installed. Does not report anything on platforms newer than PE 3.x.

#### `pe_version`

Returns the version of Puppet Enterprise installed. Does not report anything on platforms newer than PE 3.x.

#### `pe_major_version`

Returns the major version Puppet Enterprise that is installed. Does not report anything on platforms newer than PE 3.x.

#### `pe_minor_version`

Returns the minor version of Puppet Enterprise that is installed. Does not report anything on platforms newer than PE 3.x.

#### `pe_patch_version`

Returns the patch version of Puppet Enterprise that is installed.

#### `puppet_vardir`

Returns the value of the Puppet vardir setting for the node running Puppet or Puppet agent.

#### `puppet_environmentpath`

Returns the value of the Puppet environment path settings for the node running Puppet or Puppet agent.

#### `puppet_server`

Returns the Puppet agent's `server` value, which is the hostname of the Puppet master with which the agent should communicate.

#### `root_home`

Determines the root home directory.

Determines the root home directory, which depends on your operating system. Generally this is '/root'.

#### `service_provider`

Returns the default provider Puppet uses to manage services on this system

## Limitations

As of Puppet Enterprise 3.7, the stdlib module is no longer included in PE. PE users should install the most recent release of stdlib for compatibility with Puppet modules.

For an extensive list of supported operating systems, see [metadata.json](https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/metadata.json)

## Development

Puppet modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve. We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things. For more information, see our [module contribution guide](https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/CONTRIBUTING.md).

To report or research a bug with any part of this module, please go to
[http://tickets.puppetlabs.com/browse/MODULES](http://tickets.puppetlabs.com/browse/MODULES).

## Contributors

The list of contributors can be found at: [https://github.com/puppetlabs/puppetlabs-stdlib/graphs/contributors](https://github.com/puppetlabs/puppetlabs-stdlib/graphs/contributors).
