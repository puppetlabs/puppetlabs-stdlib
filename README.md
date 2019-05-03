# stdlib

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with stdlib](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    1. [Classes](#classes)
    1. [Defined Types](#defined-types)
    1. [Data Types](#data-types)
    1. [Facts](#facts)
    1. [Functions](#functions)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
1. [Contributors](#contributors)

<a id="module-description"></a>
## Module Description

This module provides a standard library of resources for Puppet modules. Puppet modules make heavy use of this standard library. The stdlib module adds the following resources to Puppet:

 * Stages
 * Facts
 * Functions
 * Defined types
 * Data types
 * Providers

> *Note:* As of version 3.7, Puppet Enterprise no longer includes the stdlib module. If you're running Puppet Enterprise, you should install the most recent release of stdlib for compatibility with Puppet modules.

<a id="setup"></a>
## Setup

[Install](https://puppet.com/docs/puppet/latest/modules_installing.html) the stdlib module to add the functions, facts, and resources of this standard library to Puppet.

If you are authoring a module that depends on stdlib, be sure to [specify dependencies](https://puppet.com/docs/puppet/latest/modules_metadata.html#specifying-dependencies-in-modules) in your metadata.json.

<a id="usage"></a>
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

<a id="reference"></a>
## Reference

* [Public classes](#public-classes)
* [Private classes](#private-classes)
* [Defined types](#defined-types)
* [Data types](#data-types)
* [Facts](#facts)
* [Functions](#functions)

<a id="classes"></a>
### Classes

<a id="public-classes"></a>
#### Public classes

The `stdlib` class has no parameters.

<a id="private-classes"></a>
#### Private classes

* `stdlib::stages`: Manages a standard set of run stages for Puppet.

<a id="defined-types"></a>
### Defined types

#### `file_line`

Ensures that a given line is contained within a file. The implementation matches the full line, including whitespace at the beginning and end. If the line is not contained in the given file, Puppet appends the line to the end of the file to ensure the desired state. Multiple resources can be declared to manage multiple lines in the same file.

Example:

```puppet
file_line { 'sudo_rule':
  path => '/etc/sudoers',
  line => '%sudo ALL=(ALL) ALL',
}

file_line { 'sudo_rule_nopw':
  path => '/etc/sudoers',
  line => '%sudonopw ALL=(ALL) NOPASSWD: ALL',
}
```

In the example above, Puppet ensures that both of the specified lines are contained in the file `/etc/sudoers`.

Match Example:

```puppet
file_line { 'bashrc_proxy':
  ensure => present,
  path   => '/etc/bashrc',
  line   => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
  match  => '^export\ HTTP_PROXY\=',
}
```

In the example above, `match` looks for a line beginning with 'export' followed by 'HTTP_PROXY' and replaces it with the value in line.

Match Example:

```puppet
file_line { 'bashrc_proxy':
  ensure             => present,
  path               => '/etc/bashrc',
  line               => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
  match              => '^export\ HTTP_PROXY\=',
  append_on_no_match => false,
}
```

In this code example, `match` looks for a line beginning with export followed by 'HTTP_PROXY' and replaces it with the value in line. If a match is not found, then no changes are made to the file.

Examples of `ensure => absent`:

This type has two behaviors when `ensure => absent` is set.

The first is to set `match => ...` and `match_for_absence => true`. Match looks for a line beginning with 'export', followed by 'HTTP_PROXY', and then deletes it. If multiple lines match, an error is raised unless the `multiple => true` parameter is set.

The `line => ...` parameter in this example would be accepted but ignored.

For example:

```puppet
file_line { 'bashrc_proxy':
  ensure            => absent,
  path              => '/etc/bashrc',
  match             => '^export\ HTTP_PROXY\=',
  match_for_absence => true,
}
```

The second way of using `ensure => absent` is to specify a `line => ...` and no match. When ensuring lines are absent, the default behavior is to remove all lines matching. This behavior can't be disabled.

For example:

```puppet
file_line { 'bashrc_proxy':
  ensure => absent,
  path   => '/etc/bashrc',
  line   => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
}
```


Encoding example:

```puppet
file_line { "XScreenSaver":
  ensure   => present,
  path     => '/root/XScreenSaver'
  line     => "*lock: 10:00:00",
  match    => '^*lock:',
  encoding => "iso-8859-1",
}
```

Files with special characters that are not valid UTF-8 give the error message "Invalid byte sequence in UTF-8". In this case, determine the correct file encoding and specify it with the `encoding` attribute.

**Autorequires:** If Puppet is managing the file that contains the line being managed, the `file_line` resource autorequires that file.

**Parameters**

All parameters are optional, unless otherwise noted.

##### `after`

Specifies the line after which Puppet adds any new lines using a regular expression. (Existing lines are added in place.)

Values: String containing a regex.

Default value: `undef`.

##### `encoding`

Specifies the correct file encoding.

Values: String specifying a valid Ruby character encoding.

Default: 'UTF-8'.

##### `ensure`

Specifies whether the resource is present.

Values: 'present', 'absent'.

Default value: 'present'.

##### `line`

**Required.**

Sets the line to be added to the file located by the `path` parameter.

Values: String.

##### `match`

Specifies a regular expression to compare against existing lines in the file; if a match is found, it is replaced rather than adding a new line.

Values: String containing a regex.

Default value: `undef`.


##### `match_for_absence`

Specifies whether a match should be applied when `ensure => absent`. If set to `true` and match is set, the line that matches is deleted. If set to `false` (the default), match is ignored when `ensure => absent` and the value of `line` is used instead. Ignored when `ensure => present`.

Boolean.

Default value: `false`.

##### `multiple`

Specifies whether `match` and `after` can change multiple lines. If set to `false`, allows file_line to replace only one line and raises an error if more than one will be replaced. If set to `true`, allows file_line to replace one or more lines.

Values: `true`, `false`.

Default value: `false`.


##### `name`

Specifies the name to use as the identity of the resource. If you want the resource namevar to differ from the supplied `title` of the resource, specify it with `name`.

Values: String.

Default value: The value of the title.

##### `path`

**Required.**

Specifies the file in which Puppet ensures the line specified by `line`.

Value: String specifying an absolute path to the file.

##### `replace`

Specifies whether the resource overwrites an existing line that matches the `match` parameter when `line` does not otherwise exist.

If set to `false` and a line is found matching the `match` parameter, the line is not placed in the file.

Boolean.

Default value: `true`.

##### `replace_all_matches_not_matching_line`

Replaces all lines matched by `match` parameter, even if `line` already exists in the file.

Default value: `false`.

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

<a id="functions"></a>
### Functions

#### `abs`

**Deprecated:** This function has been replaced with a built-in [`abs`](https://puppet.com/docs/puppet/latest/function.html#abs) function as of Puppet 6.0.0.

Returns the absolute value of a number. For example, '-34.56' becomes '34.56'.

Argument: A single argument of either an integer or float value.

*Type*: rvalue.

#### `any2array`

Converts any object to an array containing that object. Converts empty argument lists are to empty arrays. Hashes are converted to arrays of alternating keys and values. Arrays are not touched.

Since Puppet 5.0.0, you can create new values of almost any datatype using the type system — you can use the built-in [`Array.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-array-and-tuple) function to create a new array:

    $hsh = {'key' => 42, 'another-key' => 100}
    notice(Array($hsh))

Would notice `[['key', 42], ['another-key', 100]]`

The array data type also has a special mode to "create an array if not already an array":

    notice(Array({'key' => 42, 'another-key' => 100}, true))

Would notice `[{'key' => 42, 'another-key' => 100}]`, as the `true` flag prevents the hash from being transformed into an array.

*Type*: rvalue.

#### `any2bool`

Converts any object to a Boolean:

* Strings such as 'Y', 'y', '1', 'T', 't', 'TRUE', 'yes', 'true' return `true`.
* Strings such as '0', 'F', 'f', 'N', 'n', 'FALSE', 'no', 'false' return `false`.
* Booleans return their original value.
* A number (or a string representation of a number) greater than 0 returns `true`, otherwise `false`.
* An undef value returns `false`.
* Anything else returns `true`.

See the built-in [`Boolean.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-boolean)

*Type*: rvalue.

#### `assert_private`

Sets the current class or definition as private. Calling the class or defined type from outside the current module fails.

For example, `assert_private()` called in class `foo::bar` outputs the following message if class is called from outside module `foo`: `Class foo::bar is private.`

To specify the error message you want to use:

```puppet
assert_private("You're not supposed to do that!")
```

*Type*: statement.

#### `base64`

Converts a string to and from base64 encoding. Requires an `action` ('encode', 'decode') and either a plain or base64-encoded `string`, and an optional `method` ('default', 'strict', 'urlsafe').

For backward compatibility, `method` is set as `default` if not specified.

> **Note**: This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

Since Puppet 4.8.0, the `Binary` data type can be used to produce base 64 encoded strings.

See the built-in [`String.new`](https://puppet.com/docs/puppet/latest/function.html#binary-value-to-string) and [`Binary.new`](https://puppet.com/docs/puppet/latest/function.html#creating-a-binary) functions.

See the built-in [`binary_file`](https://puppet.com/docs/puppet/latest/function.html#binary_file) function for reading a file with binary (non UTF-8) content.

    # encode a string as if it was binary
    $encodestring = String(Binary('thestring', '%s'))
    # decode a Binary assuming it is an UTF-8 String
    $decodestring = String(Binary("dGhlc3RyaW5n"), "%s")

**Examples:**

```puppet
base64('encode', 'hello')
base64('encode', 'hello', 'default')
# return: "aGVsbG8=\n"

base64('encode', 'hello', 'strict')
# return: "aGVsbG8="

base64('decode', 'aGVsbG8=')
base64('decode', 'aGVsbG8=\n')
base64('decode', 'aGVsbG8=', 'default')
base64('decode', 'aGVsbG8=\n', 'default')
base64('decode', 'aGVsbG8=', 'strict')
# return: "hello"

base64('encode', 'https://puppetlabs.com', 'urlsafe')
# return: "aHR0cHM6Ly9wdXBwZXRsYWJzLmNvbQ=="

base64('decode', 'aHR0cHM6Ly9wdXBwZXRsYWJzLmNvbQ==', 'urlsafe')
# return: "https://puppetlabs.com"
```

*Type*: rvalue.

#### `basename`

Returns the `basename` of a path. An optional argument strips the extension. For example:

```puppet
basename('/path/to/a/file.ext')            => 'file.ext'
basename('relative/path/file.ext')         => 'file.ext'
basename('/path/to/a/file.ext', '.ext')    => 'file'
```

*Type*: rvalue.

#### `bool2num`

Converts a Boolean to a number. Converts values:

* `false`, 'f', '0', 'n', and 'no' to 0.
* `true`, 't', '1', 'y', and 'yes' to 1.

Argument: a single Boolean or string as an input.

Since Puppet 5.0.0, you can create values for almost any data type using the type system — you can use the built-in [`Numeric.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-numeric), [`Integer.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-integer), and [`Float.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-float)
functions to convert to numeric values:

    notice(Integer(false)) # Notices 0
    notice(Float(true))    # Notices 1.0

*Type*: rvalue.

#### `bool2str`

Converts a Boolean to a string using optionally supplied arguments. The optional second and third arguments represent what true and false are converted to respectively. If only one argument is given, it is converted from a Boolean to a string containing `true` or `false`.

*Examples:*

```puppet
bool2str(true)                    => `true`
bool2str(true, 'yes', 'no')       => 'yes'
bool2str(false, 't', 'f')         => 'f'
```

Arguments: Boolean.

Since Puppet 5.0.0, you can create new values for almost any
data type using the type system — you can use the built-in
[`String.new`](https://puppet.com/docs/puppet/latest/function.html#boolean-to-string)
function to convert to String, with many different format options:

    notice(String(false))         # Notices 'false'
    notice(String(true))          # Notices 'true'
    notice(String(false, '%y'))   # Notices 'yes'
    notice(String(true, '%y'))    # Notices 'no'

*Type*: rvalue.

#### `camelcase`

**Deprecated:** This function has been replaced with a built-in [`camelcase`](https://puppet.com/docs/puppet/latest/function.html#camelcase) function as of Puppet 6.0.0.

Converts the case of a string or all strings in an array to CamelCase (mixed case).

Arguments: Either an array or string. Returns the same type of argument as it received, but in CamelCase form.

*Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

 *Type*: rvalue.

#### `capitalize`

**Deprecated:** This function has been replaced with a built-in [`capitalize`](https://puppet.com/docs/puppet/latest/function.html#capitalize) function as of Puppet 6.0.0.

Capitalizes the first character of a string or array of strings and lowercases the remaining characters of each string.

Arguments: either a single string or an array as an input. *Type*: rvalue.

*Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

#### `ceiling`

**Deprecated:** This function has been replaced with a built-in [`ceiling`](https://puppet.com/docs/puppet/latest/function.html#ceiling) function as of Puppet 6.0.0.

Returns the smallest integer greater than or equal to the argument.

Arguments: A single numeric value.

*Type*: rvalue.

#### `chomp`

**Deprecated:** This function has been replaced with a built-in [`chomp`](https://puppet.com/docs/puppet/latest/function.html#chomp) function as of Puppet 6.0.0.

Removes the record separator from the end of a string or an array of strings; for example, 'hello\n' becomes 'hello'.

Arguments: a single string or array.

*Type*: rvalue.

#### `chop`

**Deprecated:** This function has been replaced with a built-in [`chop`](https://puppet.com/docs/puppet/latest/function.html#chop) function as of Puppet 6.0.0.

Returns a new string with the last character removed. If the string ends with '\r\n', both characters are removed. Applying `chop` to an empty string returns an empty string. To only remove record separators, use the `chomp` function.

Arguments: A string or an array of strings as input.

*Type*: rvalue.

#### `clamp`

Keeps value within the range [Min, X, Max] by sort based on integer value (parameter order doesn't matter). Strings are converted and compared numerically. Arrays of values are flattened into a list for further handling. For example:

  * `clamp('24', [575, 187])` returns 187.
  * `clamp(16, 88, 661)` returns 88.
  * `clamp([4, 3, '99'])` returns 4.

Arguments: strings, arrays, or numerics.

Since Puppet 6.0.0, you can use built-in functions to get the same result:

    [$minval, $maxval, $value_to_clamp].sort[1]

*Type*: rvalue.

#### `concat`

Appends the contents of multiple arrays onto the first array given. For example:

  * `concat(['1','2','3'],'4')` returns ['1','2','3','4'].
  * `concat(['1','2','3'],'4',['5','6','7'])` returns ['1','2','3','4','5','6','7'].

Since Puppet 4.0, you can use the `+` operator for concatenation of arrays and merge of hashes, and the `<<` operator for appending:

    ['1','2','3'] + ['4','5','6'] + ['7','8','9'] # returns ['1','2','3','4','5','6','7','8','9']
    [1, 2, 3] << 4 # returns [1, 2, 3, 4]
    [1, 2, 3] << [4, 5] # returns [1, 2, 3, [4, 5]]

*Type*: rvalue.

#### `convert_base`

Converts a given integer or base 10 string representing an integer to a specified base, as a string. For example:

  * `convert_base(5, 2)` results in: '101'
  * `convert_base('254', '16')` results in: 'fe'

Since Puppet 4.5.0, you can do this with the built-in [`String.new`](https://puppet.com/docs/puppet/latest/function.html#integer-to-string) function, with various formatting options:

    $binary_repr = String(5, '%b') # results in "101"
    $hex_repr = String(254, '%x')  # results in "fe"
    $hex_repr = String(254, '%#x') # results in "0xfe"

#### `count`

Takes an array as the first argument and an optional second argument.
It counts the number of elements in an array that is equal to the second argument.
If called with only an array, it counts the number of elements that are not nil/undef/empty-string.

> **Note**: Equality is tested with a Ruby method. It is subject to what Ruby considers
to be equal. For strings, equality is case sensitive.

In Puppet core, counting is done using a combination of the built-in functions
[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) (since Puppet 4.0.0) and
[`length`](https://puppet.com/docs/puppet/latest/function.html#length) (since Puppet 5.5.0, before that in stdlib).

This example shows counting values that are not `undef`:

    notice([42, "hello", undef].filter |$x| { $x =~ NotUndef }.length)

Would notice 2.

*Type*: rvalue.

#### `deep_merge`

Recursively merges two or more hashes together and returns the resulting hash.

```puppet
$hash1 = {'one' => 1, 'two' => 2, 'three' => { 'four' => 4 } }
$hash2 = {'two' => 'dos', 'three' => { 'five' => 5 } }
$merged_hash = deep_merge($hash1, $hash2)
```

The resulting hash is equivalent to:

```puppet
$merged_hash = { 'one' => 1, 'two' => 'dos', 'three' => { 'four' => 4, 'five' => 5 } }
```

If there is a duplicate key that is a hash, they are recursively merged. If there is a duplicate key that is not a hash, the key in the rightmost hash takes precedence.

*Type*: rvalue.

#### `defined_with_params`

Takes a resource reference and an optional hash of attributes. Returns `true` if a resource with the specified attributes has already been added to the catalog. Returns `false` otherwise.

```puppet
user { 'dan':
  ensure => present,
}

if ! defined_with_params(User[dan], {'ensure' => 'present' }) {
  user { 'dan': ensure => present, }
}
```

*Type*: rvalue.

#### `delete`

Deletes all instances of a given element from an array, substring from a string, or key from a hash.

For example:

* `delete(['a','b','c','b'], 'b')` returns ['a','c'].
* `delete('abracadabra', 'bra')` returns 'acada'.
* `delete({'a' => 1,'b' => 2,'c' => 3},['b','c'])` returns {'a'=> 1}.
* `delete(['ab', 'b'], 'b')` returns ['ab'].

Since Puppet 4.0.0, the minus (`-`) operator deletes values from arrays and deletes keys from a hash:

    ['a', 'b', 'c', 'b'] - 'b'
    # would return ['a', 'c']

    {'a'=>1,'b'=>2,'c'=>3} - ['b','c'])
    # would return {'a' => '1'}

You can perform a global delete from a string with the built-in
[`regsubst`](https://puppet.com/docs/puppet/latest/function.html#regsubst) function.

    'abracadabra'.regsubst(/bra/, '', 'G')
    # would return 'acada'

In general, the built-in
[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function
can filter out entries from arrays and hashes based on a combination of keys and values.

*Type*: rvalue.

#### `delete_at`

Deletes a determined indexed value from an array.

For example: `delete_at(['a','b','c'], 1)` returns ['a','c'].

Since Puppet 4, this can be done with the built-in
[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function:

    ['a', 'b', 'c'].filter |$pos, $val | { $pos != 1 } # returns ['a', 'c']
    ['a', 'b', 'c', 'd'].filter |$pos, $val | { $pos % 2 != 0 } # returns ['b', 'd']

Or, if you want to delete from the beginning or the end of the array — or from both ends at the same time — use the slice operator `[ ]`:

    $array[0, -1] # the same as all the values
    $array[2, -1] # all but the first 2 elements
    $array[0, -3] # all but the last 2 elements
    $array[1, -2] # all but the first and last element

*Type*: rvalue.

#### `delete_regex`

Deletes all instances of a given element from an array or hash that match a provided regular expression. A string is treated as a one-item array.

*Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

For example:

* `delete_regex(['a','b','c','b'], 'b')` returns ['a','c'].
* `delete_regex({'a' => 1,'b' => 2,'c' => 3},['b','c'])` returns {'a'=> 1}.
* `delete_regex(['abf', 'ab', 'ac'], '^ab.*')` returns ['ac'].
* `delete_regex(['ab', 'b'], 'b')` returns ['ab'].

Since Puppet 4.0.0, do the equivalent with the built-in
[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function:

    ["aaa", "aba", "aca"].filter |$val| { $val !~ /b/ }
    # Would return: ['aaa', 'aca']

*Type*: rvalue.

#### `delete_values`

Deletes all instances of a given value from a hash.

For example:

* `delete_values({'a'=>'A','b'=>'B','c'=>'C','B'=>'D'}, 'B')` returns {'a'=>'A','c'=>'C','B'=>'D'}

Since Puppet 4.0.0, do the equivalent with the built-in
[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function:

    $array.filter |$val| { $val != 'B' }
    $hash.filter |$key, $val| { $val != 'B' }

*Type*: rvalue.

#### `delete_undef_values`

Deletes all instances of the `undef` value from an array or hash.

For example:

* `$hash = delete_undef_values({a=>'A', b=>'', c=>`undef`, d => false})` returns {a => 'A', b => '', d => false}.

Since Puppet 4.0.0, do the equivalent with the built-in
[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function:

    $array.filter |$val| { $val =~ NotUndef }
    $hash.filter |$key, $val| { $val =~ NotUndef }

*Type*: rvalue.

#### `deprecation`

Prints deprecation warnings and logs a warning once for a given key:

```puppet
deprecation(key, message)
```

Arguments:

* A string specifying the key: To keep the number of messages low during the lifetime of a Puppet process, only one message per key is logged.
* A string specifying the message: the text to be logged.

*Type*: Statement.

**Settings that affect `deprecation`**

Other settings in Puppet affect the stdlib `deprecation` function:

* [`disable_warnings`](https://puppet.com/docs/puppet/latest/configuration.html#disablewarnings)
* [`max_deprecations`](https://puppet.com/docs/puppet/latest/configuration.html#maxdeprecations)
* [`strict`](https://puppet.com/docs/puppet/latest/configuration.html#strict):

    * `error`: Fails immediately with the deprecation message
    * `off`: Output emits no messages.
    * `warning`: Logs all warnings. This is the default setting.

* The environment variable `STDLIB_LOG_DEPRECATIONS`

  Specifies whether or not to log deprecation warnings. This is especially useful for automated tests to avoid flooding your logs before you are ready to migrate.

  This variable is Boolean, with the following effects:

  * `true`: Functions log a warning.
  * `false`: No warnings are logged.
  * No value set: Puppet 4 emits warnings, but Puppet 3 does not.

#### `difference`

Returns the difference between two arrays. The returned array is a copy of the original array, removing any items that also appear in the second array.

For example:

* `difference(["a","b","c"],["b","c","d"])` returns ["a"].

Since Puppet 4, the minus (`-`) operator in the Puppet language does the same:

    ['a', 'b', 'c'] - ['b', 'c', 'd']
    # would return ['a']

*Type*: rvalue.

#### `dig`

**Deprecated:** This function has been replaced with a built-in [`dig`](https://puppet.com/docs/puppet/latest/function.html#dig) function as of Puppet 4.5.0. Use [`dig44()`](#dig44) for backwards compatibility or use the new version.

Retrieves a value within multiple layers of hashes and arrays via an array of keys containing a path. The function goes through the structure by each path component and tries to return the value at the end of the path.

In addition to the required path argument, the function accepts the default argument. It is returned if the path is not correct, if no value was found, or if any other error has occurred.

```ruby
$data = {
  'a' => {
    'b' => [
      'b1',
      'b2',
      'b3',
    ]
  }
}

$value = dig($data, ['a', 'b', 2])
# $value = 'b3'

# with all possible options
$value = dig($data, ['a', 'b', 2], 'not_found')
# $value = 'b3'

# using the default value
$value = dig($data, ['a', 'b', 'c', 'd'], 'not_found')
# $value = 'not_found'
```

1. **$data** The data structure we are working with.
2. **['a', 'b', 2]** The path array.
3. **'not_found'** The default value. It is returned if nothing is found.

Default value: `undef`.

*Type*: rvalue.

#### `dig44`

Retrieves a value within multiple layers of hashes and arrays via an array of keys containing a path. The function goes through the structure by each path component and tries to return the value at the end of the path.

In addition to the required path argument, the function accepts the default argument. It is returned if the path is incorrect, if no value was found, or if any other error has occurred.

```ruby
$data = {
  'a' => {
    'b' => [
      'b1',
      'b2',
      'b3',
    ]
  }
}

$value = dig44($data, ['a', 'b', 2])
# $value = 'b3'

# with all possible options
$value = dig44($data, ['a', 'b', 2], 'not_found')
# $value = 'b3'

# using the default value
$value = dig44($data, ['a', 'b', 'c', 'd'], 'not_found')
# $value = 'not_found'
```

*Type*: rvalue.

1. **$data** The data structure we are working with.
2. **['a', 'b', 2]** The path array.
3. **'not_found'** The default value. It will be returned if nothing is found.
   (optional, defaults to `undef`)

#### `dirname`

Returns the `dirname` of a path. For example, `dirname('/path/to/a/file.ext')` returns '/path/to/a'.

*Type*: rvalue.

#### `dos2unix`

Returns the Unix version of the given string. Very useful when using a File resource with a cross-platform template.

```puppet
file { $config_file:
  ensure  => file,
  content => dos2unix(template('my_module/settings.conf.erb')),
}
```

See also [unix2dos](#unix2dos).

*Type*: rvalue.

#### `downcase`

**Deprecated:** This function has been replaced with a built-in [`downcase`](https://puppet.com/docs/puppet/latest/function.html#downcase) function as of Puppet 6.0.0.

Converts the case of a string or of all strings in an array to lowercase.

*Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

*Type*: rvalue.

#### `empty`

**Deprecated:** This function has been replaced with a built-in [`empty`](https://puppet.com/docs/puppet/latest/function.html#empty) function as of Puppet 5.5.0.

Returns `true` if the argument is an array or hash that contains no elements, or an empty string. Returns `false` when the argument is a numerical value.

*Type*: rvalue.

#### `enclose_ipv6`

Takes an array of IP addresses and encloses the ipv6 addresses with square brackets.

*Type*: rvalue.

#### `ensure_packages`

Takes a list of packages in an array or hash and installs them only if they don't already exist. Optionally takes a hash as a second parameter to be passed as the third argument to the `ensure_resource()` or `ensure_resources()` function.

*Type*: statement.

For an array:

```puppet
ensure_packages(['ksh','openssl'], {'ensure' => 'present'})
```

For a hash:

```puppet
ensure_packages({'ksh' => { ensure => '20120801-1' } ,  'mypackage' => { source => '/tmp/myrpm-1.0.0.x86_64.rpm', provider => "rpm" }}, {'ensure' => 'present'})
```

#### `ensure_resource`

Takes a resource type, title, and a hash of attributes that describe the resource(s).

```
user { 'dan':
  ensure => present,
}
```

This example only creates the resource if it does not already exist:

  `ensure_resource('user', 'dan', {'ensure' => 'present' })`

If the resource already exists, but does not match the specified parameters, this function attempts to recreate the resource, leading to a duplicate resource definition error.

An array of resources can also be passed in, and each will be created with the type and parameters specified if it doesn't already exist.

`ensure_resource('user', ['dan','alex'], {'ensure' => 'present'})`

*Type*: statement.

#### `ensure_resources`

Creates resource declarations from a hash, but doesn't conflict with resources that are already declared.

Specify a resource type and title and a hash of attributes that describe the resource(s).

```puppet
user { 'dan':
  gid => 'mygroup',
  ensure => present,
}

ensure_resources($user)
```

Pass in a hash of resources. Any listed resources that don't already exist will be created with the type and parameters specified:

    ensure_resources('user', {'dan' => { gid => 'mygroup', uid => '600' } ,  'alex' => { gid => 'mygroup' }}, {'ensure' => 'present'})

From Hiera backend:

```yaml
userlist:
  dan:
    gid: 'mygroup'
    uid: '600'
  alex:
    gid: 'mygroup'
```

```puppet
ensure_resources('user', hiera_hash('userlist'), {'ensure' => 'present'})
```

#### `stdlib::extname`

Returns the Extension (the Portion of Filename in Path starting from the last Period).

Example usage:

```puppet
stdlib::extname('test.rb')       => '.rb'
stdlib::extname('a/b/d/test.rb') => '.rb'
stdlib::extname('test')          => ''
stdlib::extname('.profile')      => ''
```

*Type*: rvalue.

#### `stdlib::ip_in_range`

A Puppet function that determines whether an IPv4 address is within the IPv4 CIDR. Returns true if the ipaddress is within the given CIDRs.

```puppet
$ranges = ['192.168.0.0/24', '10.10.10.0/24']
$valid_ip = stdlib::ip_in_range('10.10.10.53', $ranges) # $valid_ip == true
```

*Type*: rvalue.

#### `fact`

Return the value of a given fact. Supports the use of dot-notation for referring to structured facts. If a fact requested does not exist, returns Undef.

Example usage:

```puppet
fact('kernel')
fact('osfamily')
fact('os.architecture')
```

Array indexing:

```puppet
$first_processor  = fact('processors.models.0')
$second_processor = fact('processors.models.1')
```

Fact containing a "." in the fact name:

```puppet
fact('vmware."VRA.version"')
```

#### `flatten`

**Deprecated:** This function has been replaced with a built-in [`flatten`](https://puppet.com/docs/puppet/latest/function.html#flatten) function as of Puppet 5.5.0.

Flattens deeply nested arrays and returns a single flat array as a result.

For example, `flatten(['a', ['b', ['c']]])` returns ['a','b','c'].

*Type*: rvalue.

#### `floor`

**Deprecated:** This function has been replaced with a built-in [`floor`](https://puppet.com/docs/puppet/latest/function.html#floor) function as of Puppet 6.0.0.

Returns the largest integer less than or equal to the argument.

Arguments: A single numeric value.

*Type*: rvalue.

#### `fqdn_rand_string`

Generates a random alphanumeric string, combining the `$fqdn` fact and an optional seed for repeatable randomness. Optionally, you can specify a character set for the function (defaults to alphanumeric).

*Usage:*

```puppet
fqdn_rand_string(LENGTH, [CHARSET], [SEED])
```

*Examples:*

```puppet
fqdn_rand_string(10)
fqdn_rand_string(10, 'ABCDEF!@#$%^')
fqdn_rand_string(10, '', 'custom seed')
```

Arguments:

* An integer, specifying the length of the resulting string.
* Optionally, a string specifying the character set.
* Optionally, a string specifying the seed for repeatable randomness.

*Type*: rvalue.

#### `fqdn_rotate`

Rotates an array or string a random number of times, combining the `$fqdn` fact and an optional seed for repeatable randomness.

*Usage:*

```puppet
fqdn_rotate(VALUE, [SEED])
```

*Examples:*

```puppet
fqdn_rotate(['a', 'b', 'c', 'd'])
fqdn_rotate('abcd')
fqdn_rotate([1, 2, 3], 'custom seed')
```

*Type*: rvalue.

#### `fqdn_uuid`

Returns a [RFC 4122](https://tools.ietf.org/html/rfc4122) valid version 5 UUID based on an FQDN string under the DNS namespace:

  * fqdn_uuid('puppetlabs.com') returns '9c70320f-6815-5fc5-ab0f-debe68bf764c'
  * fqdn_uuid('google.com') returns '64ee70a4-8cc1-5d25-abf2-dea6c79a09c8'

*Type*: rvalue.

#### `get_module_path`

Returns the absolute path of the specified module for the current environment.

```puppet
$module_path = get_module_path('stdlib')
```

Since Puppet 5.4.0, the built-in [`module_directory`](https://puppet.com/docs/puppet/latest/function.html#module_directory) function does the same thing and will return the path to the first module found, if given multiple values or an array.

*Type*: rvalue.

#### `getparam`
Returns the value of a resource's parameter.

Arguments: A resource reference and the name of the parameter.

> Note: User defined resource types are evaluated lazily.

*Examples:*

```puppet
# define a resource type with a parameter
define example_resource($param) {
}

# declare an instance of that type
example_resource { "example_resource_instance":
    param => "'the value we are getting in this example''"
}

# Because of order of evaluation, a second definition is needed
# that will be evaluated after the first resource has been declared
#
define example_get_param {
  # This will notice the value of the parameter
  notice(getparam(Example_resource["example_resource_instance"], "param"))
}

# Declare an instance of the second resource type - this will call notice
example_get_param { 'show_notify': }
```

Would notice: 'the value we are getting in this example'

Since Puppet 4.0.0, you can get a parameter value by using its data type
and the [ ] operator. The example below is equivalent to a call to getparam():

```puppet
Example_resource['example_resource_instance']['param']
```

#### `getvar`
**Deprecated:** This function has been replaced with a built-in [`getvar`](https://puppet.com/docs/puppet/latest/function.html#getvar)
function as of Puppet 6.0.0. The new version also supports digging into a structured value.

Looks up a variable in a remote namespace.

For example:

```puppet
$foo = getvar('site::data::foo')
# Equivalent to $foo = $site::data::foo
```

This is useful if the namespace itself is stored in a string:

```puppet
$datalocation = 'site::data'
$bar = getvar("${datalocation}::bar")
# Equivalent to $bar = $site::data::bar
```

*Type*: rvalue.

#### `glob`

Returns an array of strings of paths matching path patterns.

Arguments: A string or an array of strings specifying path patterns.

```puppet
$confs = glob(['/etc/**/*.conf', '/opt/**/*.conf'])
```

*Type*: rvalue.

#### `grep`

Searches through an array and returns any elements that match the provided regular expression.

For example, `grep(['aaa','bbb','ccc','aaaddd'], 'aaa')` returns ['aaa','aaaddd'].

Since Puppet 4.0.0, the built-in [`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function does the "same" — as any logic can be used to filter, as opposed to just regular expressions:

    ['aaa', 'bbb', 'ccc', 'aaaddd']. filter |$x| { $x =~ 'aaa' }

*Type*: rvalue.

#### `has_interface_with`

Returns a Boolean based on kind and value:

  * macaddress
  * netmask
  * ipaddress
  * network

*Examples:*

```puppet
has_interface_with("macaddress", "x:x:x:x:x:x")
has_interface_with("ipaddress", "127.0.0.1")    => true
```

If no kind is given, then the presence of the interface is checked:

```puppet
has_interface_with("lo")                        => true
```

*Type*: rvalue.

#### `has_ip_address`

Returns `true` if the client has the requested IP address on some interface. This function iterates through the `interfaces` fact and checks the `ipaddress_IFACE` facts, performing a simple string comparison.

Arguments: A string specifying an IP address.

*Type*: rvalue.

#### `has_ip_network`

Returns `true` if the client has an IP address within the requested network. This function iterates through the `interfaces` fact and checks the `network_IFACE` facts, performing a simple string comparision.

Arguments: A string specifying an IP address.

*Type*: rvalue.

#### `has_key`
**Deprecated:** This function has been replaced with the built-in operator `in`.

Determines if a hash has a certain key value.

*Example*:

```
$my_hash = {'key_one' => 'value_one'}
if has_key($my_hash, 'key_two') {
  notice('we will not reach here')
}
if has_key($my_hash, 'key_one') {
  notice('this will be printed')
}
```

Since Puppet 4.0.0, this can be achieved in the Puppet language with the following equivalent expression:

    $my_hash = {'key_one' => 'value_one'}
    if 'key_one' in $my_hash {
      notice('this will be printed')
    }

*Type*: rvalue.

#### `hash`

**Deprecated:** This function has been replaced with the built-in ability to create a new value of almost any
data type - see the built-in [`Hash.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-hash-and-struct) function
in Puppet.

Converts an array into a hash.

For example (deprecated), `hash(['a',1,'b',2,'c',3])` returns {'a'=>1,'b'=>2,'c'=>3}.

For example (built-in), `Hash(['a',1,'b',2,'c',3])` returns {'a'=>1,'b'=>2,'c'=>3}.

*Type*: rvalue.

#### `intersection`

Returns an array an intersection of two.

For example, `intersection(["a","b","c"],["b","c","d"])` returns ["b","c"].

*Type*: rvalue.

#### `is_a`

Boolean check to determine whether a variable is of a given data type. This is equivalent to the `=~` type checks. This function is available only in Puppet 4, or in Puppet 3 with the "future" parser.

```
foo = 3
$bar = [1,2,3]
$baz = 'A string!'

if $foo.is_a(Integer) {
  notify  { 'foo!': }
}
if $bar.is_a(Array) {
  notify { 'bar!': }
}
if $baz.is_a(String) {
  notify { 'baz!': }
}
```

* See the [the Puppet type system](https://puppet.com/docs/puppet/latest/lang_data.html) for more information about types.
* See the [`assert_type()`](https://puppet.com/docs/puppet/latest/function.html#asserttype) function for flexible ways to assert the type of a value.

#### `is_absolute_path`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the given path is absolute.

*Type*: rvalue.

#### `is_array`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the variable passed to this function is an array.

*Type*: rvalue.

#### `is_bool`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the variable passed to this function is a Boolean.

*Type*: rvalue.

#### `is_domain_name`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the string passed to this function is a syntactically correct domain name.

*Type*: rvalue.

#### `is_email_address`

Returns true if the string passed to this function is a valid email address.

*Type*: rvalue.


#### `is_float`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the variable passed to this function is a float.

*Type*: rvalue.

#### `is_function_available`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Accepts a string as an argument and determines whether the Puppet runtime has access to a function by that name. It returns `true` if the function exists, `false` if not.

*Type*: rvalue.

#### `is_hash`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the variable passed to this function is a hash.

*Type*: rvalue.

#### `is_integer`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the variable returned to this string is an integer.

*Type*: rvalue.

#### `is_ip_address`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the string passed to this function is a valid IP address.

*Type*: rvalue.

#### `is_ipv6_address`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the string passed to this function is a valid IPv6 address.

*Type*: rvalue.

#### `is_ipv4_address`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the string passed to this function is a valid IPv4 address.

*Type*: rvalue.

#### `is_mac_address`

Returns `true` if the string passed to this function is a valid MAC address.

*Type*: rvalue.

#### `is_numeric`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the variable passed to this function is a number.

*Type*: rvalue.

#### `is_string`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Returns `true` if the variable passed to this function is a string.

*Type*: rvalue.

#### `join`

**Deprecated:** This function has been replaced with a built-in [`join`](https://puppet.com/docs/puppet/latest/function.html#join) function as of Puppet 5.5.0.

Joins an array into a string using a separator. For example, `join(['a','b','c'], ",")` results in: "a,b,c".

*Type*: rvalue.

#### `join_keys_to_values`

Joins each key of a hash to that key's corresponding value with a separator, returning the result as strings.

If a value is an array, the key is prefixed to each element. The return value is a flattened array.

For example, `join_keys_to_values({'a'=>1,'b'=>[2,3]}, " is ")` results in ["a is 1","b is 2","b is 3"].

Since Puppet 5.0.0, there is more control over the formatting (including indentations and line breaks, delimiters around arrays and hash entries, between key/values in hash entries, and individual
formatting of values in the array) - see the
built-in [`String.new`](https://docs.puppet.com/puppet/latest/function.html#conversion-to-string) function and its formatting options for `Array` and `Hash`.

*Type*: rvalue.

#### `keys`

**Deprecated:** This function has been replaced with a built-in [`keys`](https://puppet.com/docs/puppet/latest/function.html#keys) function as of Puppet 5.5.0.

Returns the keys of a hash as an array.

*Type*: rvalue.

#### `length`

**Deprecated:** This function has been replaced with a built-in [`length`](https://puppet.com/docs/puppet/latest/function.html#length) function as of Puppet 5.5.0.

Returns the length of a given string, array or hash. Replaces the deprecated `size()` function.

*Type*: rvalue.

#### `loadyaml`

Loads a YAML file containing an array, string, or hash, and returns the data in the corresponding native data type.

For example:

```puppet
$myhash = loadyaml('/etc/puppet/data/myhash.yaml')
```

The second parameter is returned if the file was not found or could not be parsed.

For example:

```puppet
$myhash = loadyaml('no-file.yaml', {'default'=>'value'})
```

*Type*: rvalue.

#### `loadjson`

Loads a JSON file containing an array, string, or hash, and returns the data in the corresponding native data type.

For example:

The first parameter can be an absolute file path, or a URL.

```puppet
$myhash = loadjson('/etc/puppet/data/myhash.json')
```

The second parameter is returned if the file was not found or could not be parsed.

For example:

```puppet
  $myhash = loadjson('no-file.json', {'default'=>'value'})
  ```

*Type*: rvalue.

#### `load_module_metadata`

Loads the metadata.json of a target module. Can be used to determine module version and authorship for dynamic support of modules.

```puppet
$metadata = load_module_metadata('archive')
notify { $metadata['author']: }
```

When a module's metadata file is absent, the catalog compilation fails. To avoid this failure, do the following:

```
$metadata = load_module_metadata('mysql', true)
if empty($metadata) {
  notify { "This module does not have a metadata.json file.": }
}
```

*Type*: rvalue.

#### `lstrip`

**Deprecated:** This function has been replaced with a built-in [`lstrip`](https://puppet.com/docs/puppet/latest/function.html#lstrip) function as of Puppet 6.0.0.

Strips spaces to the left of a string.

*Type*: rvalue.

#### `max`

**Deprecated:** This function has been replaced with a built-in [`max`](https://puppet.com/docs/puppet/latest/function.html#max) function as of Puppet 6.0.0.

Returns the highest value of all arguments. Requires at least one argument.

Arguments: A numeric or a string representing a number.

*Type*: rvalue.

#### `member`

This function determines if a variable is a member of an array. The variable can be a string, an array, or a fixnum.

For example, `member(['a','b'], 'b')` and `member(['a','b','c'], ['b','c'])` return `true`, while `member(['a','b'], 'c')` and `member(['a','b','c'], ['c','d'])` return `false`.

*Note*: This function does not support nested arrays. If the first argument contains nested arrays, it will not recurse through them.

Since Puppet 4.0.0, you can perform the same in the Puppet language. For single values,
use the operator `in`:

    'a' in ['a', 'b']  # true

And for arrays, use the operator `-` to compute a diff:

    ['d', 'b'] - ['a', 'b', 'c'] == []  # false because 'd' is not subtracted
    ['a', 'b'] - ['a', 'b', 'c'] == []  # true because both 'a' and 'b' are subtracted

Also note that since Puppet 5.2.0, the general form to test the content of an array or hash is to use the built-in [`any`](https://puppet.com/docs/puppet/latest/function.html#any) and [`all`](https://puppet.com/docs/puppet/latest/function.html#all) functions.

*Type*: rvalue.

#### `merge`

Merges two or more hashes together and returns the resulting hash.

*Example*:

```puppet
$hash1 = {'one' => 1, 'two' => 2}
$hash2 = {'two' => 'dos', 'three' => 'tres'}
$merged_hash = merge($hash1, $hash2)
# The resulting hash is equivalent to:
# $merged_hash =  {'one' => 1, 'two' => 'dos', 'three' => 'tres'}
```

When there is a duplicate key, the key in the rightmost hash takes precedence.

Since Puppet 4.0.0, you can use the + operator to achieve the same merge.

    $merged_hash = $hash1 + $hash2

If merge is given a single `Iterable` (`Array`, `Hash`, etc.), it calls a block with
up to three parameters, and merges each resulting Hash into the accumulated result. All other types
of values returned from the block (for example, `undef`) are skipped, not merged.

The codeblock takes two or three parameters:
* With two parameters, the codeblock gets the current hash and each value (for hash the value is a [key, value] tuple).
* With three parameters, the codeblock gets the current hash, the key/index of each value, and the value.

If the iterable is empty, or if no hash was returned from the given block, an empty hash is returned. A call to `next()` skips that entry, and a call to `break()` ends the iteration.

Counting occurrences of strings in an array example:

```puppet
['a', 'b', 'c', 'c', 'd', 'b'].merge | $hsh, $v | { { $v => $hsh[$v].lest || { 0 } + 1 } }
# would result in { a => 1, b => 2, c => 2, d => 1 }
```

Skipping values for entries that are longer than one char example:

```puppet
['a', 'b', 'c', 'c', 'd', 'b', 'blah', 'blah'].merge | $hsh, $v | { if $v =~ String[1,1] { { $v => $hsh[$v].lest || { 0 } + 1 } } }
# would result in { a => 1, b => 2, c => 2, d => 1 } since 'blah' is longer than 2 chars
```

The iterative `merge()` has an advantage over a general `reduce()` in that the constructed hash
does not have to be copied in each iteration and it performs better with large inputs.

*Type*: rvalue.

#### `min`

**Deprecated:** This function has been replaced with a built-in [`min`](https://puppet.com/docs/puppet/latest/function.html#min) function as of Puppet 6.0.0.

Returns the lowest value of all arguments. Requires at least one argument.

Arguments: A numeric or a string representing a number.

*Type*: rvalue.

#### `num2bool`

Converts a number, or a string representation of a number, into a true Boolean.
Zero or anything non-numeric becomes `false`.
Numbers greater than zero become `true`.

Since Puppet 5.0.0, the same can be achieved with the Puppet type system.
See the [`Boolean.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-boolean)
function in Puppet for the many available type conversions.

    Boolean(0) # false
    Boolean(1) # true

*Type*: rvalue.

#### `os_version_gte`

Checks to see if the OS version is at least a certain version. Note that only the major version is taken into account.

Example usage:
```
  if os_version_gte('Debian', '9') { }
  if os_version_gte('Ubuntu', '18.04') { }
```

Returns:
  - Boolean(0) # When OS is below the given version.
  - Boolean(1) # When OS is equal to or greater than the given version.

#### `parsejson`

Converts a string of JSON into the correct Puppet structure (as a hash, array, string, integer, or a combination of such).

Arguments:
* The JSON string to convert, as a first argument.
* Optionally, the result to return if conversion fails, as a second error.

*Type*: rvalue.

#### `parseyaml`

Converts a string of YAML into the correct Puppet structure.

Arguments:
* The YAML string to convert, as a first argument.
* Optionally, the result to return if conversion fails, as a second error.

*Type*: rvalue.

#### `pick`

From a list of values, returns the first value that is not undefined or an empty string. Takes any number of arguments, and raises an error if all values are undefined or empty.

```puppet
$real_jenkins_version = pick($::jenkins_version, '1.449')
```

*Type*: rvalue.

#### `pick_default`

Returns the first value in a list of values. Unlike the `pick()` function, `pick_default()` does not fail if all arguments are empty. This allows it to use an empty value as default.

*Type*: rvalue.

#### `prefix`

Applies a prefix to all elements in an array, or to the keys in a hash.

For example:

* `prefix(['a','b','c'], 'p')` returns ['pa','pb','pc'].
* `prefix({'a'=>'b','b'=>'c','c'=>'d'}, 'p')` returns {'pa'=>'b','pb'=>'c','pc'=>'d'}.

Since Puppet 4.0.0, modify values in array by using the built-in [`map`](https://docs.puppet.com/puppet/latest/function.html#map) function.
This example does the same as the first example above:

        ['a', 'b', 'c'].map |$x| { "p${x}" }

*Type*: rvalue.

#### `pry`

Invokes a pry debugging session in the current scope object. Useful for debugging manifest code at specific points during a compilation. Should be used only when running `puppet apply` or running a Puppet master in the foreground. Requires the `pry` gem to be installed in Puppet's rubygems.

*Examples:*

```puppet
pry()
```

In a pry session, useful commands include:

* Run `catalog` to see the contents currently compiling catalog.
* Run `cd catalog` and `ls` to see catalog methods and instance variables.
* Run `@resource_table` to see the current catalog resource table.

#### `pw_hash`

Hashes a password using the crypt function. Provides a hash usable on most POSIX systems.

The first argument to this function is the password to hash. If it is `undef` or an empty string, this function returns `undef`.

The second argument to this function is which type of hash to use. It will be converted into the appropriate crypt(3) hash specifier. Valid hash types are:

|Hash type            |Specifier|
|---------------------|---------|
|MD5                  |1        |
|SHA-256              |5        |
|SHA-512 (recommended)|6        |

The third argument to this function is the salt to use.

This function uses the Puppet master's implementation of crypt(3). If your environment contains several different operating systems, ensure that they are compatible before using this function.

*Type*: rvalue.

*Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

#### `range`

Extrapolates a range as an array when given in the form of '(start, stop)'. For example, `range("0", "9")` returns [0,1,2,3,4,5,6,7,8,9]. Zero-padded strings are converted to integers automatically, so `range("00", "09")` returns [0,1,2,3,4,5,6,7,8,9].

Non-integer strings are accepted:

* `range("a", "c")` returns ["a","b","c"].
* `range("host01", "host10")` returns ["host01", "host02", ..., "host09", "host10"].

You must explicitly include trailing zeros, or the underlying Ruby function fails.

Passing a third argument causes the generated range to step by that interval. For example:

* `range("0", "9", "2")` returns ["0","2","4","6","8"].

> Note: The Puppet language supports `Integer` and `Float` ranges by using the type system. They are suitable for iterating a given number of times.

See the built-in [`step`](https://docs.puppet.com/puppet/latest/function.html#step) function in Puppet for skipping values.

    Integer[0, 9].each |$x| { notice($x) } # notices 0, 1, 2, ... 9

*Type*: rvalue.

#### `regexpescape`

Regexp escape a string or array of strings. Requires either a single string or an array as an input.

*Type*: rvalue.

#### `reject`

Searches through an array and rejects all elements that match the provided regular expression.

For example, `reject(['aaa','bbb','ccc','aaaddd'], 'aaa')` returns ['bbb','ccc'].

Since Puppet 4.0.0, the same is true with the built-in [`filter`](https://docs.puppet.com/puppet/latest/function.html#filter) function in Puppet.
The equivalent of the stdlib `reject` function:

    ['aaa','bbb','ccc','aaaddd'].filter |$x| { $x !~ /aaa/ }

*Type*: rvalue.

#### `reverse`

Reverses the order of a string or array.

> *Note*: The same can be done with the built-in [`reverse_each`](https://docs.puppet.com/puppet/latest/function.html#reverse_each) function in Puppet.


#### `round`

**Deprecated:** This function has been replaced with a built-in [`round`](https://puppet.com/docs/puppet/latest/function.html#round) function as of Puppet 6.0.0.

Rounds a number to the nearest integer.

*Type*: rvalue.

#### `rstrip`

**Deprecated:** This function has been replaced with a built-in [`rstrip`](https://puppet.com/docs/puppet/latest/function.html#rstrip) function as of Puppet 6.0.0.

Strips spaces to the right of the string.

*Type*: rvalue.

#### `seeded_rand`

Takes an integer max value and a string seed value and returns a repeatable random integer smaller than max. Similar to `fqdn_rand`, but does not add node specific data to the seed.

*Type*: rvalue.

#### `seeded_rand_string`

Generates a consistent (based on seed value) random string. Useful for generating matching passwords for different hosts.

#### `shell_escape`

Escapes a string so that it can be safely used in a Bourne shell command line. Note that the resulting string should be used unquoted and is not intended for use in either double or single quotes. This function behaves the same as Ruby's `Shellwords.shellescape()` function; see the [Ruby documentation](http://ruby-doc.org/stdlib-2.3.0/libdoc/shellwords/rdoc/Shellwords.html#method-c-shellescape).

For example:

```puppet
shell_escape('foo b"ar') => 'foo\ b\"ar'
```

*Type*: rvalue.

#### `shell_join`

Builds a command line string from a given array of strings. Each array item is escaped for Bourne shell. All items are then joined together, with a single space in between. This function behaves the same as Ruby's `Shellwords.shelljoin()` function; see the [Ruby documentation](http://ruby-doc.org/stdlib-2.3.0/libdoc/shellwords/rdoc/Shellwords.html#method-c-shelljoin).

For example:

```puppet
shell_join(['foo bar', 'ba"z']) => 'foo\ bar ba\"z'
```

*Type*: rvalue.

#### `shell_split`

Splits a string into an array of tokens. This function behaves the same as Ruby's `Shellwords.shellsplit()` function; see the [ruby documentation](http://ruby-doc.org/stdlib-2.3.0/libdoc/shellwords/rdoc/Shellwords.html#method-c-shellsplit).

*Example:*

```puppet
shell_split('foo\ bar ba\"z') => ['foo bar', 'ba"z']
```

*Type*: rvalue.

#### `shuffle`

Randomizes the order of a string or array elements.

*Type*: rvalue.

#### `size`

**Deprecated:** This function has been replaced with a built-in [`size`](https://puppet.com/docs/puppet/latest/function.html#size) function as of Puppet 6.0.0 (`size` is now an alias for `length`).

Returns the number of elements in a string, an array or a hash. This function will be deprecated in a future release. For Puppet 4, use the `length` function.

*Type*: rvalue.

#### `sprintf_hash`

**Deprecated:** The same functionality can be achieved with the built-in [`sprintf`](https://docs.puppet.com/puppet/latest/function.html#sprintf) function as of Puppet 4.10.10 and 5.3.4. This function will be removed in a future release.

Performs printf-style formatting with named references of text.

The first parameter is a format string describing how to format the rest of the parameters in the hash. See Ruby documentation for [`Kernel::sprintf`](https://ruby-doc.org/core-2.4.2/Kernel.html#method-i-sprintf) for details about this function.

For example:

```puppet
$output = sprintf_hash('String: %<foo>s / number converted to binary: %<number>b',
                       { 'foo' => 'a string', 'number' => 5 })
# $output = 'String: a string / number converted to binary: 101'
```

*Type*: rvalue

#### `sort`

**Deprecated:** This function has been replaced with a built-in [`sort`](https://puppet.com/docs/puppet/latest/function.html#sort) function as of Puppet 6.0.0.

Sorts strings and arrays lexically.

*Type*: rvalue.

> *Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

#### `squeeze`

Replaces consecutive repeats (such as 'aaaa') in a string with a single character. Returns a new string.

*Type*: rvalue.

#### `str2bool`

Converts certain strings to a Boolean. This attempts to convert strings that contain the values '1', 'true', 't', 'y', or 'yes' to `true`. Strings that contain values '0', 'false', 'f', 'n', or 'no', or that are an empty string or undefined are converted to `false`. Any other value causes an error. These checks are case insensitive.

Since Puppet 5.0.0, the same can be achieved with the Puppet type system.
See the [`Boolean.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-boolean)
function in Puppet for the many available type conversions.

    Boolean('false'), Boolean('n'), Boolean('no') # all false
    Boolean('true'), Boolean('y'), Boolean('yes') # all true

*Type*: rvalue.

#### `str2saltedsha512`

Converts a string to a salted-SHA512 password hash, used for OS X versions 10.7 or greater. Returns a hex version of a salted-SHA512 password hash, which can be inserted into Puppet manifests as a valid password attribute.

*Type*: rvalue.

> *Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

#### `strftime`

**Deprecated:** This function has been replaced with a built-in [`strftime`](https://puppet.com/docs/puppet/latest/function.html#strftime) function as of Puppet 4.8.0.

Returns formatted time.

For example, `strftime("%s")` returns the time since Unix epoch, and `strftime("%Y-%m-%d")` returns the date.

Arguments: A string specifying the time in `strftime` format. See the Ruby [strftime](https://ruby-doc.org/core-2.1.9/Time.html#method-i-strftime) documentation for details.

*Type*: rvalue.

> *Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

*Format:*

* `%a`: The abbreviated weekday name ('Sun')
* `%A`: The full weekday name ('Sunday')
* `%b`: The abbreviated month name ('Jan')
* `%B`: The full month name ('January')
* `%c`: The preferred local date and time representation
* `%C`: Century (20 in 2009)
* `%d`: Day of the month (01..31)
* `%D`: Date (%m/%d/%y)
* `%e`: Day of the month, blank-padded ( 1..31)
* `%F`: Equivalent to %Y-%m-%d (the ISO 8601 date format)
* `%h`: Equivalent to %b
* `%H`: Hour of the day, 24-hour clock (00..23)
* `%I`: Hour of the day, 12-hour clock (01..12)
* `%j`: Day of the year (001..366)
* `%k`: Hour, 24-hour clock, blank-padded ( 0..23)
* `%l`: Hour, 12-hour clock, blank-padded ( 0..12)
* `%L`: Millisecond of the second (000..999)
* `%m`: Month of the year (01..12)
* `%M`: Minute of the hour (00..59)
* `%n`: Newline (\n)
* `%N`: Fractional seconds digits, default is 9 digits (nanosecond)
  * `%3N`: Millisecond (3 digits)
  * `%6N`: Microsecond (6 digits)
  * `%9N`: Nanosecond (9 digits)
* `%p`: Meridian indicator ('AM' or 'PM')
* `%P`: Meridian indicator ('am' or 'pm')
* `%r`: Time, 12-hour (same as %I:%M:%S %p)
* `%R`: Time, 24-hour (%H:%M)
* `%s`: Number of seconds since the Unix epoch, 1970-01-01 00:00:00 UTC.
* `%S`: Second of the minute (00..60)
* `%t`: Tab character (	)
* `%T`: Time, 24-hour (%H:%M:%S)
* `%u`: Day of the week as a decimal, Monday being 1. (1..7)
* `%U`: Week number of the current year, starting with the first Sunday as the first day of the first week (00..53)
* `%v`: VMS date (%e-%b-%Y)
* `%V`: Week number of year according to ISO 8601 (01..53)
* `%W`: Week number of the current year, starting with the first Monday as the first day of the first week (00..53)
* `%w`: Day of the week (Sunday is 0, 0..6)
* `%x`: Preferred representation for the date alone, no time
* `%X`: Preferred representation for the time alone, no date
* `%y`: Year without a century (00..99)
* `%Y`: Year with century
* `%z`: Time zone as hour offset from UTC (for example +0900)
* `%Z`: Time zone name
* `%%`: Literal '%' character

#### `strip`

**Deprecated:** This function has been replaced with a built-in [`strip`](https://puppet.com/docs/puppet/latest/function.html#strip) function as of Puppet 6.0.0.

Removes leading and trailing whitespace from a string or from every string inside an array. For example, `strip("    aaa   ")` results in "aaa".

*Type*: rvalue.

#### `suffix`

Applies a suffix to all elements in an array or to all keys in a hash.

For example:

* `suffix(['a','b','c'], 'p')` returns ['ap','bp','cp'].
* `suffix({'a'=>'b','b'=>'c','c'=>'d'}, 'p')` returns {'ap'=>'b','bp'=>'c','cp'=>'d'}.

Note that since Puppet 4.0.0, you can modify values in an array using the built-in [`map`](https://docs.puppet.com/puppet/latest/function.html#map) function. This example does the same as the first example above:

    ['a', 'b', 'c'].map |$x| { "${x}p" }

*Type*: rvalue.

#### `swapcase`

Swaps the existing case of a string. For example, `swapcase("aBcD")` results in "AbCd".

*Type*: rvalue.

> *Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

#### `time`

Returns the current Unix epoch time as an integer.

For example, `time()` returns something like '1311972653'.

Since Puppet 4.8.0, the Puppet language has the data types `Timestamp` (a point in time) and `Timespan` (a duration). The following example is equivalent to calling `time()` without any arguments:

    Timestamp()

*Type*: rvalue.

#### `to_bytes`

Converts the argument into bytes.

For example, "4 kB" becomes "4096".

Arguments: A single string.

*Type*: rvalue.

#### `to_json`

Converts input into a JSON String.

For example, `{ "key" => "value" }` becomes `{"key":"value"}`.

*Type*: rvalue.

#### `to_json_pretty`

Converts input into a pretty JSON String.

For example, `{ "key" => "value" }` becomes `{\n  \"key\": \"value\"\n}`.

*Type*: rvalue.

#### `to_yaml`

Converts input into a YAML String.

For example, `{ "key" => "value" }` becomes `"---\nkey: value\n"`.

*Type*: rvalue.

#### `try_get_value`

**Deprecated:** Replaced by `dig()`.

Retrieves a value within multiple layers of hashes and arrays.

Arguments:

* A string containing a path, as the first argument. Provide this argument as a string of hash keys or array indexes starting with zero and separated by the path separator character (default "/"). This function goes through the structure by each path component and tries to return the value at the end of the path.

* A default argument as a second argument. This argument is returned if the path is not correct, if no value was found, or if any other error has occurred.
* The path separator character as a last argument.

```ruby
$data = {
  'a' => {
    'b' => [
      'b1',
      'b2',
      'b3',
    ]
  }
}

$value = try_get_value($data, 'a/b/2')
# $value = 'b3'

# with all possible options
$value = try_get_value($data, 'a/b/2', 'not_found', '/')
# $value = 'b3'

# using the default value
$value = try_get_value($data, 'a/b/c/d', 'not_found')
# $value = 'not_found'

# using custom separator
$value = try_get_value($data, 'a|b', [], '|')
# $value = ['b1','b2','b3']
```

1. **$data** The data structure we are working with.
2. **'a/b/2'** The path string.
3. **'not_found'** The default value. It will be returned if nothing is found.
   (optional, defaults to *`undef`*)
4. **'/'** The path separator character.
   (optional, defaults to *'/'*)

*Type*: rvalue.

#### `type3x`

**Deprecated:** This function will be removed in a future release.

Returns a string description of the type of a given value. The type can be a string, array, hash, float, integer, or Boolean. For Puppet 4, use the new type system instead.

Arguments:

* string
* array
* hash
* float
* integer
* Boolean

*Type*: rvalue.

#### `type_of`

This function is provided for backwards compatibility, but the built-in [type() function](https://puppet.com/docs/puppet/latest/function.html#type) provided by Puppet is preferred.

Returns the literal type of a given value. Requires Puppet 4. Useful for comparison of types with `<=` such as in `if type_of($some_value) <= Array[String] { ... }` (which is equivalent to `if $some_value =~ Array[String] { ... }`).

*Type*: rvalue.

#### `union`

Returns a union of two or more arrays, without duplicates.

For example, `union(["a","b","c"],["b","c","d"])` returns ["a","b","c","d"].

*Type*: rvalue.

#### `unique`

Removes duplicates from strings and arrays.

For example, `unique("aabbcc")` returns 'abc', and `unique(["a","a","b","b","c","c"])` returns ["a","b","c"].

*Type*: rvalue.

#### `unix2dos`

Returns the DOS version of a given string. Useful when using a File resource with a cross-platform template.

*Type*: rvalue.

```puppet
file { $config_file:
  ensure  => file,
  content => unix2dos(template('my_module/settings.conf.erb')),
}
```

See also [dos2unix](#dos2unix).

#### `upcase`

**Deprecated:** This function has been replaced with a built-in [`upcase`](https://puppet.com/docs/puppet/latest/function.html#upcase) function as of Puppet 6.0.0.

Converts an object, array, or hash of objects to uppercase. Objects to be converted must respond to upcase.

For example, `upcase('abcd')` returns 'ABCD'.

*Type*: rvalue.

*Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

#### `uriescape`

URLEncodes a string or array of strings.

Arguments: Either a single string or an array of strings.

*Type*: rvalue.

> *Note:* This function is an implementation of a Ruby class and might not be UTF8 compatible. To ensure compatibility, use this function with Ruby 2.4.0 or greater.

#### `validate_absolute_path`

Validates that a given string represents an absolute path in the filesystem. Works for Windows and Unix style paths.

The following values pass:

```puppet
$my_path = 'C:/Program Files (x86)/Puppet Labs/Puppet'
validate_absolute_path($my_path)
$my_path2 = '/var/lib/puppet'
validate_absolute_path($my_path2)
$my_path3 = ['C:/Program Files (x86)/Puppet Labs/Puppet','C:/Program Files/Puppet Labs/Puppet']
validate_absolute_path($my_path3)
$my_path4 = ['/var/lib/puppet','/usr/share/puppet']
validate_absolute_path($my_path4)
```

The following values fail, causing compilation to terminate:

```puppet
validate_absolute_path(true)
validate_absolute_path('../var/lib/puppet')
validate_absolute_path('var/lib/puppet')
validate_absolute_path([ 'var/lib/puppet', '/var/foo' ])
validate_absolute_path([ '/var/lib/puppet', 'var/foo' ])
$undefined = `undef`
validate_absolute_path($undefined)
```

*Type*: statement.

#### `validate_array`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Validates that all passed values are array data structures. Terminates catalog compilation if any value fails this check.

The following values pass:

```puppet
$my_array = [ 'one', 'two' ]
validate_array($my_array)
```

The following values fail, causing compilation to terminate:

```puppet
validate_array(true)
validate_array('some_string')
$undefined = `undef`
validate_array($undefined)
```

*Type*: statement.

#### `validate_augeas`

Validates a string using an Augeas lens.

Arguments:

* The string to test, as the first argument.
* The name of the Augeas lens to use, as the second argument.
* Optionally, a list of paths which should **not** be found in the file, as a third argument.
* Optionally, an error message to raise and show to the user, as a fourth argument.

If Augeas fails to parse the string with the lens, the compilation terminates with a parse error.

The `$file` variable points to the location of the temporary file being tested in the Augeas tree.

For example, to make sure your $passwdcontent never contains user `foo`, include the third argument:

```puppet
validate_augeas($passwdcontent, 'Passwd.lns', ['$file/foo'])
```

To raise and display an error message, include the fourth argument:

```puppet
validate_augeas($sudoerscontent, 'Sudoers.lns', [], 'Failed to validate sudoers content with Augeas')
```

*Type*: statement.

#### `validate_bool`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Validates that all passed values are either `true` or `false`.
Terminates catalog compilation if any value fails this check.

The following values pass:

```puppet
$iamtrue = true
validate_bool(true)
validate_bool(true, true, false, $iamtrue)
```

The following values fail, causing compilation to terminate:

```puppet
$some_array = [ true ]
validate_bool("false")
validate_bool("true")
validate_bool($some_array)
```

*Type*: statement.

#### `validate_cmd`

Validates a string with an external command.

Arguments:
* The string to test, as the first argument.
* The path to a test command, as the second argument. This argument takes a % as a placeholder for the file path (if no % placeholder is given, defaults to the end of the command). If the command is launched against a tempfile containing the passed string, or returns a non-null value, compilation will terminate with a parse error.
* Optionally, an error message to raise and show to the user, as a third argument.

```puppet
# Defaults to end of path
validate_cmd($sudoerscontent, '/usr/sbin/visudo -c -f', 'Visudo failed to validate sudoers content')
```

```puppet
# % as file location
validate_cmd($haproxycontent, '/usr/sbin/haproxy -f % -c', 'Haproxy failed to validate config content')
```

*Type*: statement.

#### `validate_domain_name`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Validate that all values passed are syntactically correct domain names. Aborts catalog compilation if any value fails this check.

The following values pass:

~~~
$my_domain_name = 'server.domain.tld'
validate_domain_name($my_domain_name)
validate_domain_name('domain.tld', 'puppet.com', $my_domain_name)
~~~

The following values fail, causing compilation to abort:

~~~
validate_domain_name(1)
validate_domain_name(true)
validate_domain_name('invalid domain')
validate_domain_name('-foo.example.com')
validate_domain_name('www.example.2com')
~~~

*Type*: statement.

#### `validate_email_address`

Validate that all values passed are valid email addresses. Fail compilation if any value fails this check.

The following values will pass:

~~~
$my_email = "waldo@gmail.com"
validate_email_address($my_email)
validate_email_address("bob@gmail.com", "alice@gmail.com", $my_email)
~~~

The following values will fail, causing compilation to abort:

~~~
$some_array = [ 'bad_email@/d/efdf.com' ]
validate_email_address($some_array)
~~~

*Type*: statement.

#### `validate_hash`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Validates that all passed values are hash data structures. Terminates catalog compilation if any value fails this check.

The following values will pass:

```puppet
$my_hash = { 'one' => 'two' }
validate_hash($my_hash)
```

The following values will fail, causing compilation to terminate:

```puppet
validate_hash(true)
validate_hash('some_string')
$undefined = `undef`
validate_hash($undefined)
```

*Type*: statement.

#### `validate_integer`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Validates an integer or an array of integers. Terminates catalog compilation if any of the checks fail.

Arguments:

* An integer or an array of integers, as the first argument.
* Optionally, a maximum, as the second argument. (All elements of) the first argument must be equal to or less than this maximum.
* Optionally, a minimum, as the third argument. (All elements of) the first argument must be equal to or greater than than this maximum.

This function fails if the first argument is not an integer or array of integers, or if the second or third arguments are not convertable to an integer. However, if (and only if) a minimum is given, the second argument may be an empty string or `undef`, which serves as a placeholder to ensure the minimum check.

The following values pass:

```puppet
validate_integer(1)
validate_integer(1, 2)
validate_integer(1, 1)
validate_integer(1, 2, 0)
validate_integer(2, 2, 2)
validate_integer(2, '', 0)
validate_integer(2, `undef`, 0)
$foo = `undef`
validate_integer(2, $foo, 0)
validate_integer([1,2,3,4,5], 6)
validate_integer([1,2,3,4,5], 6, 0)
```

* Plus all of the above, but any combination of values passed as strings ('1' or "1").
* Plus all of the above, but with (correct) combinations of negative integer values.

The following values fail, causing compilation to terminate:

```puppet
validate_integer(true)
validate_integer(false)
validate_integer(7.0)
validate_integer({ 1 => 2 })
$foo = `undef`
validate_integer($foo)
validate_integer($foobaridontexist)

validate_integer(1, 0)
validate_integer(1, true)
validate_integer(1, '')
validate_integer(1, `undef`)
validate_integer(1, , 0)
validate_integer(1, 2, 3)
validate_integer(1, 3, 2)
validate_integer(1, 3, true)
```

* Plus all of the above, but any combination of values passed as strings (`false` or "false").
* Plus all of the above, but with incorrect combinations of negative integer values.
* Plus all of the above, but with non-integer items in arrays or maximum / minimum argument.

*Type*: statement.

#### `validate_ip_address`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Validates that the argument is an IP address, regardless of whether it is an IPv4 or an IPv6 address. It also validates IP address with netmask.

Arguments: A string specifying an IP address.

The following values will pass:

```puppet
validate_ip_address('0.0.0.0')
validate_ip_address('8.8.8.8')
validate_ip_address('127.0.0.1')
validate_ip_address('194.232.104.150')
validate_ip_address('3ffe:0505:0002::')
validate_ip_address('::1/64')
validate_ip_address('fe80::a00:27ff:fe94:44d6/64')
validate_ip_address('8.8.8.8/32')
```

The following values will fail, causing compilation to terminate:

```puppet
validate_ip_address(1)
validate_ip_address(true)
validate_ip_address(0.0.0.256)
validate_ip_address('::1', {})
validate_ip_address('0.0.0.0.0')
validate_ip_address('3.3.3')
validate_ip_address('23.43.9.22/64')
validate_ip_address('260.2.32.43')
```


#### `validate_legacy`

Validates a value against both a specified type and a deprecated validation function. Silently passes if both pass, errors if only one validation passes, and fails if both validations return false.

Arguments:

* The type to check the value against,
* The full name of the previous validation function,
* The value to be checked,
* An unspecified number of arguments needed for the previous validation function.

Example:

```puppet
validate_legacy('Optional[String]', 'validate_re', 'Value to be validated', ["."])
```

This function supports updating modules from Puppet 3-style argument validation (using the stdlib `validate_*` functions) to Puppet 4 data types, without breaking functionality for those depending on Puppet 3-style validation.

> Note: This function is compatible only with Puppet 4.4.0 (PE 2016.1) and later.

##### For module users

If you are running Puppet 4, the `validate_legacy` function can help you find and resolve deprecated Puppet 3 `validate_*` functions. These functions are deprecated as of stdlib version 4.13 and will be removed in a future version of stdlib.

Puppet 4 allows improved defined type checking using [data types](https://puppet.com/docs/puppet/latest/lang_data.html). Data types avoid some of the problems with Puppet 3's `validate_*` functions, which were sometimes inconsistent. For example, [validate_numeric](#validate_numeric) unintentionally allowed not only numbers, but also arrays of numbers or strings that looked like numbers.

If you run Puppet 4 and use modules with deprecated `validate_*` functions, you might encounter deprecation messages. The `validate_legacy` function makes these differences visible and makes it easier to move to the clearer Puppet 4 syntax.

The deprecation messages you get can vary, depending on the modules and data that you use. These deprecation messages appear by default only in Puppet 4:

* `Notice: Accepting previously invalid value for target type '<type>'`: This message is informational only. You're using values that are allowed by the new type, but would have been invalid by the old validation function.
* `Warning: This method is deprecated, please use the stdlib validate_legacy function`: The module has not yet upgraded to `validate_legacy`. Use the [deprecation](#deprecation) options to silence warnings for now, or submit a fix with the module's developer. See the information [for module developers](#for-module-developers) below for how to fix the issue.
* `Warning: validate_legacy(<function>) expected <type> value, got <actual type>_`: Your code passes a value that was accepted by the Puppet 3-style validation, but will not be accepted by the next version of the module. Most often, you can fix this by removing quotes from numbers or booleans.
* `Error: Evaluation Error: Error while evaluating a Resource Statement, Evaluation Error: Error while evaluating a Function Call, validate_legacy(<function>) expected <type> value, got <actual type>`: Your code passes a value that is not acceptable to either the new or the old style validation.

##### For module developers

The `validate_legacy` function helps you move from Puppet 3 style validation to Puppet 4 validation without breaking functionality your module's users depend on.

Moving to Puppet 4 type validation allows much better defined type checking using [data types](https://puppet.com/docs/puppet/latest/lang_data.html). Many of Puppet 3's `validate_*` functions have surprising holes in their validation. For example, [validate_numeric](#validate_numeric) allows not only numbers, but also arrays of numbers or strings that look like numbers, without giving you any control over the specifics.

For each parameter of your classes and defined types, choose a new Puppet 4 data type to use. In most cases, the new data type allows a different set of values than the original `validate_*` function. The situation then looks like this:

|              | `validate_` pass | `validate_` fail |
| ------------ | ---------------- | ---------------- |
| matches type | pass             | pass, notice     |
| fails type   | pass, deprecated | fail             |

The code after the validation still has to handle all possible values for now, but users of your code can change their manifests to pass only values that match the new type.

For each `validate_*` function in stdlib, there is a matching `Stdlib::Compat::*` type that allows the appropriate set of values. See the documentation in the `types/` directory in the stdlib source code for caveats.

For example, given a class that should accept only numbers, like this:

```puppet
class example($value) {
  validate_numeric($value)
```

the resulting validation code looks like this:

```puppet
class example(
  Variant[Stdlib::Compat::Numeric, Numeric] $value
) {
  validate_legacy(Numeric, 'validate_numeric', $value)
```

Here, the type of `$value` is defined as `Variant[Stdlib::Compat::Numeric, Numeric]`, which allows any `Numeric` (the new type), as well as all values previously accepted by `validate_numeric` (through `Stdlib::Compat::Numeric`).

The call to `validate_legacy` takes care of triggering the correct log or fail message for you. It requires the new type, the previous validation function name, and all arguments to that function.

If your module still supported Puppet 3, this is a breaking change. Update your `metadata.json` requirements section to indicate that your module no longer supports Puppet 3, and bump the major version of your module. With this change, all existing tests for your module should still pass. Create additional tests for the new possible values.

As a breaking change, this is also a good time to call [`deprecation`](#deprecation) for any parameters you want to get rid of, or to add additional constraints on your parameters.

After releasing this version, you can release another breaking change release where you remove all compat types and all calls to `validate_legacy`. At that time, you can also go through your code and remove any leftovers dealing with the previously possible values.

Always note such changes in your CHANGELOG and README.

#### `validate_numeric`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Validates a numeric value, or an array or string of numeric values. Terminates catalog compilation if any of the checks fail.

Arguments:

* A numeric value, or an array or string of numeric values.
* Optionally, a maximum value. (All elements of) the first argument has to be less or equal to this max.
* Optionally, a minimum value. (All elements of) the first argument has to be greater or equal to this min.

This function fails if the first argument is not a numeric (Integer or Float) or an array or string of numerics, or if the second and third arguments are not convertable to a numeric. If, and only if, a minimum is given, the second argument can be an empty string or `undef`, which serves as a placeholder to ensure the minimum check.

For passing and failing usage, see [`validate_integer`](#validate-integer). The same values pass and fail, except that `validate_numeric` also allows floating point values.

*Type*: statement.

#### `validate_re`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Performs simple validation of a string against one or more regular expressions.

Arguments:

* The string to test, as the first argument. If this argument is not a string, compilation terminates. Use quotes to force stringification.
* A stringified regular expression (without the // delimiters) or an array of regular expressions, as the second argument.
* Optionally, the error message raised and shown to the user, as a third argument.

If none of the regular expressions in the second argument match the string passed in the first argument, compilation terminates with a parse error.

The following strings validate against the regular expressions:

```puppet
validate_re('one', '^one$')
validate_re('one', [ '^one', '^two' ])
```

The following string fails to validate, causing compilation to terminate:

```puppet
validate_re('one', [ '^two', '^three' ])
```

To set the error message:

```puppet
validate_re($::puppetversion, '^2.7', 'The $puppetversion fact value does not match 2.7')
```

To force stringification, use quotes:

  ```
  validate_re("${::operatingsystemmajrelease}", '^[57]$')
  ```

*Type*: statement.

#### `validate_slength`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Validates that a string (or an array of strings) is less than or equal to a specified length

Arguments:

* A string or an array of strings, as a first argument.
* A numeric value for maximum length, as a second argument.
* Optionally, a numeric value for minimum length, as a third argument.

  The following values pass:

```puppet
validate_slength("discombobulate",17)
validate_slength(["discombobulate","moo"],17)
validate_slength(["discombobulate","moo"],17,3)
```

The following values fail:

```puppet
validate_slength("discombobulate",1)
validate_slength(["discombobulate","thermometer"],5)
validate_slength(["discombobulate","moo"],17,10)
```

*Type*: statement.

#### `validate_string`

**Deprecated:** Will be removed in a future version of stdlib. See [`validate_legacy`](#validate_legacy).

Validates that all passed values are string data structures. Aborts catalog compilation if any value fails this check.

The following values pass:

```puppet
$my_string = "one two"
validate_string($my_string, 'three')
```

The following values fail, causing compilation to terminate:

```puppet
validate_string(true)
validate_string([ 'some', 'array' ])
```

> *Note:* validate_string(`undef`) will not fail in this version of the functions API.

Instead, use:

  ```
  if $var == `undef` {
    fail('...')
  }
  ```

*Type*: statement.

#### `validate_x509_rsa_key_pair`

Validates a PEM-formatted X.509 certificate and private key using OpenSSL.
Verifies that the certificate's signature was created from the supplied key.

Fails catalog compilation if any value fails this check.

Arguments:

* An X.509 certificate as the first argument.
* An RSA private key, as the second argument.

```puppet
validate_x509_rsa_key_pair($cert, $key)
```

*Type*: statement.

#### `values`

**Deprecated:** This function has been replaced with a built-in [`values`](https://puppet.com/docs/puppet/latest/function.html#values) function as of Puppet 5.5.0.

Returns the values of a given hash.

For example, given `$hash = {'a'=1, 'b'=2, 'c'=3} values($hash)` returns [1,2,3].

*Type*: rvalue.

#### `values_at`

Finds values inside an array based on location.

Arguments:

* The array you want to analyze, as the first argument.
* Any combination of the following values, as the second argument:
  * A single numeric index
  * A range in the form of 'start-stop' (eg. 4-9)
  * An array combining the above

For example:

* `values_at(['a','b','c'], 2)` returns ['c'].
* `values_at(['a','b','c'], ["0-1"])` returns ['a','b'].
* `values_at(['a','b','c','d','e'], [0, "2-3"])` returns ['a','c','d'].

Since Puppet 4.0.0, you can slice an array with index and count directly in the language.
A negative value is taken to be "from the end" of the array, for example:

```puppet
['a', 'b', 'c', 'd'][1, 2]   # results in ['b', 'c']
['a', 'b', 'c', 'd'][2, -1]  # results in ['c', 'd']
['a', 'b', 'c', 'd'][1, -2]  # results in ['b', 'c']
```

*Type*: rvalue.

#### `zip`

Takes one element from first array given and merges corresponding elements from second array given. This generates a sequence of n-element arrays, where *n* is one more than the count of arguments. For example, `zip(['1','2','3'],['4','5','6'])` results in ["1", "4"], ["2", "5"], ["3", "6"]. *Type*: rvalue.

<a id="limitations"></a>
## Limitations

As of Puppet Enterprise 3.7, the stdlib module is no longer included in PE. PE users should install the most recent release of stdlib for compatibility with Puppet modules.

For an extensive list of supported operating systems, see [metadata.json](https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/metadata.json)

<a id="development"></a>
## Development

Puppet modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve. We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things. For more information, see our [module contribution guide](https://docs.puppet.com/forge/contributing.html).

To report or research a bug with any part of this module, please go to
[http://tickets.puppetlabs.com/browse/MODULES](http://tickets.puppetlabs.com/browse/MODULES).

<a id="contributors"></a>
## Contributors

The list of contributors can be found at: [https://github.com/puppetlabs/puppetlabs-stdlib/graphs/contributors](https://github.com/puppetlabs/puppetlabs-stdlib/graphs/contributors).
