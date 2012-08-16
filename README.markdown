# Puppet Labs Standard Library #

This module provides a "standard library" of resources for developing Puppet
Modules.  This modules will include the following additions to Puppet

 * Stages
 * Facts
 * Functions
 * Defined resource types
 * Types
 * Providers

This module is officially curated and provided by Puppet Labs.  The modules
Puppet Labs writes and distributes will make heavy use of this standard
library.

# Versions #

This module follows semver.org (v1.0.0) versioning guidelines.  The standard
library module is released as part of [Puppet
Enterprise](http://puppetlabs.com/puppet/puppet-enterprise/) and as a result
older versions of Puppet Enterprise that Puppet Labs still supports will have
bugfix maintenance branches periodically "merged up" into master.  The current
list of integration branches are:

 * v2.1.x (v2.1.1 released in PE 1.2, 1.2.1, 1.2.3, 1.2.4)
 * v2.2.x (Never released as part of PE, only to the Forge)
 * v2.3.x (Released in PE 2.5.x)
 * master (mainline development branch)

The first Puppet Enterprise version including the stdlib module is Puppet
Enterprise 1.2.

# Compatibility #

The stdlib module does not work with Puppet versions released prior to Puppet
2.6.0.

## stdlib 2.x ##

All stdlib releases in the 2.0 major version support Puppet 2.6 and Puppet 2.7.

## stdlib 3.x ##

The 3.0 major release of stdlib drops support for Puppet 2.6.  Stdlib 3.x
supports Puppet 2.7.

# Functions #

abs
---
Returns the absolute value of a number, for example -34.56 becomes 
34.56. Takes a single integer and float value as an argument.


- *Type*: rvalue

bool2num
--------
Converts a boolean to a number. Converts the values:
false, f, 0, n, and no to 0
true, t, 1, y, and yes to 1
    Requires a single boolean or string as an input.


- *Type*: rvalue

capitalize
----------
Capitalizes the first letter of a string or array of strings.
Requires either a single string or an array as an input.


- *Type*: rvalue

chomp
-----
Removes the record separator from the end of a string or an array of 
strings, for example `hello\n` becomes `hello`.
Requires a single string or array as an input.


- *Type*: rvalue

chop
----
Returns a new string with the last character removed. If the string ends 
with `\r\n`, both characters are removed. Applying chop to an empty 
string returns an empty string. If you wish to merely remove record 
separators then you should use the `chomp` function.
Requires a string or array of strings as input.


- *Type*: rvalue

create_resources
----------------
Converts a hash into a set of resources and adds them to the catalog.

This function takes two mandatory arguments: a resource type, and a hash describing
a set of resources. The hash should be in the form `{title => {parameters} }`:

    # A hash of user resources:
    $myusers = {
      'nick' => { uid    => '1330',
                  group  => allstaff,
                  groups => ['developers', 'operations', 'release'], }
      'dan'  => { uid    => '1308',
                  group  => allstaff,
                  groups => ['developers', 'prosvc', 'release'], }
    }

    create_resources(user, $myusers)

A third, optional parameter may be given, also as a hash:

    $defaults => {
      'ensure'   => present,
      'provider' => 'ldap',
    }

    create_resources(user, $myusers, $defaults)

The values given on the third argument are added to the parameters of each resource
present in the set given on the second argument. If a parameter is present on both
the second and third arguments, the one on the second argument takes precedence.

This function can be used to create defined resources and classes, as well
as native resources.


- *Type*: statement

crit
----
Log a message on the server at level crit.

- *Type*: statement

debug
-----
Log a message on the server at level debug.

- *Type*: statement

defined
-------
Determine whether
a given class or resource type is defined. This function can also determine whether a
specific resource has been declared. Returns true or false. Accepts class names,
type names, and resource references.

The `defined` function checks both native and defined types, including types
provided as plugins via modules. Types and classes are both checked using their names:

    defined("file")
    defined("customtype")
    defined("foo")
    defined("foo::bar")

Resource declarations are checked using resource references, e.g.
`defined( File['/tmp/myfile'] )`. Checking whether a given resource
has been declared is, unfortunately, dependent on the parse order of
the configuration, and the following code will not work:

    if defined(File['/tmp/foo']) {
        notify("This configuration includes the /tmp/foo file.")
    }
    file {"/tmp/foo":
        ensure => present,
    }

However, this order requirement refers to parse order only, and ordering of
resources in the configuration graph (e.g. with `before` or `require`) does not
affect the behavior of `defined`.

- *Type*: rvalue

defined_with_params
-------------------
Takes a resource reference and an optional hash of attributes.

Returns true if a resource with the specified attributes has already been added
to the catalog, and false otherwise.

    user { 'dan':
      ensure => present,
    }

    if ! defined_with_params(User[dan], {'ensure' => 'present' }) {
      user { 'dan': ensure => present, }
    }


- *Type*: rvalue

delete
------
Deletes a selected element from an array.

*Examples:*

    delete(['a','b','c'], 'b')

Would return: ['a','c']


- *Type*: rvalue

delete_at
---------
Deletes a determined indexed value from an array.

*Examples:*

    delete_at(['a','b','c'], 1)

Would return: ['a','c']


- *Type*: rvalue

downcase
--------
Converts the case of a string or all strings in an array to lower case.


- *Type*: rvalue

emerg
-----
Log a message on the server at level emerg.

- *Type*: statement

empty
-----
Returns true if the variable is empty.


- *Type*: rvalue

ensure_resource
---------------
Takes a resource type, title, and a list of attributes that describe a
resource.

    user { 'dan':
      ensure => present,
    }

This example only creates the resource if it does not already exist:

    ensure_resource('user, 'dan', {'ensure' => 'present' })

If the resource already exists but does not match the specified parameters,
this function will attempt to recreate the resource leading to a duplicate
resource definition error.



- *Type*: statement

err
---
Log a message on the server at level err.

- *Type*: statement

extlookup
---------
This is a parser function to read data from external files, this version
uses CSV files but the concept can easily be adjust for databases, yaml
or any other queryable data source.

The object of this is to make it obvious when it's being used, rather than
magically loading data in when an module is loaded I prefer to look at the code
and see statements like:

    $snmp_contact = extlookup("snmp_contact")

The above snippet will load the snmp_contact value from CSV files, this in its
own is useful but a common construct in puppet manifests is something like this:

    case $domain {
      "myclient.com": { $snmp_contact = "John Doe <john@myclient.com>" }
      default:        { $snmp_contact = "My Support <support@my.com>" }
    }

Over time there will be a lot of this kind of thing spread all over your manifests
and adding an additional client involves grepping through manifests to find all the
places where you have constructs like this.

This is a data problem and shouldn't be handled in code, a using this function you
can do just that.

First you configure it in site.pp:

    $extlookup_datadir = "/etc/puppet/manifests/extdata"
    $extlookup_precedence = ["%{fqdn}", "domain_%{domain}", "common"]

The array tells the code how to resolve values, first it will try to find it in
web1.myclient.com.csv then in domain_myclient.com.csv and finally in common.csv

Now create the following data files in /etc/puppet/manifests/extdata:

    domain_myclient.com.csv:
      snmp_contact,John Doe <john@myclient.com>
      root_contact,support@%{domain}
      client_trusted_ips,192.168.1.130,192.168.10.0/24

    common.csv:
      snmp_contact,My Support <support@my.com>
      root_contact,support@my.com

Now you can replace the case statement with the simple single line to achieve
the exact same outcome:

   $snmp_contact = extlookup("snmp_contact")

The above code shows some other features, you can use any fact or variable that
is in scope by simply using %{varname} in your data files, you can return arrays
by just having multiple values in the csv after the initial variable name.

In the event that a variable is nowhere to be found a critical error will be raised
that will prevent your manifest from compiling, this is to avoid accidentally putting
in empty values etc.  You can however specify a default value:

   $ntp_servers = extlookup("ntp_servers", "1.${country}.pool.ntp.org")

In this case it will default to "1.${country}.pool.ntp.org" if nothing is defined in
any data file.

You can also specify an additional data file to search first before any others at use
time, for example:

    $version = extlookup("rsyslog_version", "present", "packages")
    package{"rsyslog": ensure => $version }

This will look for a version configured in packages.csv and then in the rest as configured
by $extlookup_precedence if it's not found anywhere it will default to `present`, this kind
of use case makes puppet a lot nicer for managing large amounts of packages since you do not
need to edit a load of manifests to do simple things like adjust a desired version number.

Precedence values can have variables embedded in them in the form %{fqdn}, you could for example do:

    $extlookup_precedence = ["hosts/%{fqdn}", "common"]

This will result in /path/to/extdata/hosts/your.box.com.csv being searched.

This is for back compatibility to interpolate variables with %. % interpolation is a workaround for a problem that has been fixed: Puppet variable interpolation at top scope used to only happen on each run.

- *Type*: rvalue

fail
----
Fail with a parse error.

- *Type*: statement

file
----
Return the contents of a file.  Multiple files
can be passed, and the first file that exists will be read in.

- *Type*: rvalue

flatten
-------
This function flattens any deeply nested arrays and returns a single flat array
as a result.

*Examples:*

    flatten(['a', ['b', ['c']]])

Would return: ['a','b','c']


- *Type*: rvalue

fqdn_rand
---------
Generates random numbers based on the node's fqdn. Generated random values
will be a range from 0 up to and excluding n, where n is the first parameter.
The second argument specifies a number to add to the seed and is optional, for example:

    $random_number = fqdn_rand(30)
    $random_number_seed = fqdn_rand(30,30)

- *Type*: rvalue

fqdn_rotate
-----------
Rotates an array a random number of times based on a nodes fqdn.


- *Type*: rvalue

generate
--------
Calls an external command on the Puppet master and returns
the results of the command.  Any arguments are passed to the external command as
arguments.  If the generator does not exit with return code of 0,
the generator is considered to have failed and a parse error is
thrown.  Generators can only have file separators, alphanumerics, dashes,
and periods in them.  This function will attempt to protect you from
malicious generator calls (e.g., those with '..' in them), but it can
never be entirely safe.  No subshell is used to execute
generators, so all shell metacharacters are passed directly to
the generator.

- *Type*: rvalue

get_module_path
---------------
Returns the absolute path of the specified module for the current
environment.

Example:
  $module_path = get_module_path('stdlib')


- *Type*: rvalue

getvar
------
Lookup a variable in a remote namespace.

For example:

    $foo = getvar('site::data::foo')
    # Equivalent to $foo = $site::data::foo

This is useful if the namespace itself is stored in a string:

    $datalocation = 'site::data'
    $bar = getvar("${datalocation}::bar")
    # Equivalent to $bar = $site::data::bar


- *Type*: rvalue

grep
----
This function searches through an array and returns any elements that match
the provided regular expression.

*Examples:*

    grep(['aaa','bbb','ccc','aaaddd'], 'aaa')

Would return:

    ['aaa','aaaddd']


- *Type*: rvalue

has_key
-------
Determine if a hash has a certain key value.

Example:

    $my_hash = {'key_one' => 'value_one'}
    if has_key($my_hash, 'key_two') {
      notice('we will not reach here')
    }
    if has_key($my_hash, 'key_one') {
      notice('this will be printed')
    }



- *Type*: rvalue

hash
----
This function converts and array into a hash.

*Examples:*

    hash(['a',1,'b',2,'c',3])

Would return: {'a'=>1,'b'=>2,'c'=>3}


- *Type*: rvalue

include
-------
Evaluate one or more classes.

- *Type*: statement

info
----
Log a message on the server at level info.

- *Type*: statement

inline_template
---------------
Evaluate a template string and return its value.  See 
[the templating docs](http://docs.puppetlabs.com/guides/templating.html) for 
more information.  Note that if multiple template strings are specified, their 
output is all concatenated and returned as the output of the function.

- *Type*: rvalue

is_array
--------
Returns true if the variable passed to this function is an array.


- *Type*: rvalue

is_domain_name
--------------
Returns true if the string passed to this function is a syntactically correct domain name.


- *Type*: rvalue

is_float
--------
Returns true if the variable passed to this function is a float.


- *Type*: rvalue

is_hash
-------
Returns true if the variable passed to this function is a hash.


- *Type*: rvalue

is_integer
----------
Returns true if the variable returned to this string is an integer.


- *Type*: rvalue

is_ip_address
-------------
Returns true if the string passed to this function is a valid IP address.


- *Type*: rvalue

is_mac_address
--------------
Returns true if the string passed to this function is a valid mac address.


- *Type*: rvalue

is_numeric
----------
Returns true if the variable passed to this function is a number.


- *Type*: rvalue

is_string
---------
Returns true if the variable passed to this function is a string.


- *Type*: rvalue

join
----
This function joins an array into a string using a seperator.

*Examples:*

    join(['a','b','c'], ",")

Would result in: "a,b,c"


- *Type*: rvalue

keys
----
Returns the keys of a hash as an array.


- *Type*: rvalue

loadyaml
--------
Load a YAML file containing an array, string, or hash, and return the data
in the corresponding native data type.

For example:

    $myhash = loadyaml('/etc/puppet/data/myhash.yaml')


- *Type*: rvalue

lstrip
------
Strips leading spaces to the left of a string.


- *Type*: rvalue

md5
---
Returns a MD5 hash value from a provided string.

- *Type*: rvalue

member
------
This function determines if a variable is a member of an array.

*Examples:*

    member(['a','b'], 'b')

Would return: true

    member(['a','b'], 'c')

Would return: false


- *Type*: rvalue

merge
-----
Merges two or more hashes together and returns the resulting hash.

For example:

    $hash1 = {'one' => 1, 'two', => 2}
    $hash2 = {'two' => 'dos', 'three', => 'tres'}
    $merged_hash = merge($hash1, $hash2)
    # The resulting hash is equivalent to:
    # $merged_hash =  {'one' => 1, 'two' => 'dos', 'three' => 'tres'}

When there is a duplicate key, the key in the rightmost hash will "win."



- *Type*: rvalue

notice
------
Log a message on the server at level notice.

- *Type*: statement

num2bool
--------
This function converts a number into a true boolean. Zero becomes false. Numbers
higher then 0 become true.


- *Type*: rvalue

parsejson
---------
This function accepts JSON as a string and converts into the correct Puppet
structure.


- *Type*: rvalue

parseyaml
---------
This function accepts YAML as a string and converts it into the correct 
Puppet structure.


- *Type*: rvalue

prefix
------
This function applies a prefix to all elements in an array.

*Examles:*

    prefix(['a','b','c'], 'p')

Will return: ['pa','pb','pc']


- *Type*: rvalue

range
-----
When given range in the form of (start, stop) it will extrapolate a range as
an array.

*Examples:*

    range("0", "9")

Will return: [0,1,2,3,4,5,6,7,8,9]

    range("00", "09")

Will return: [0,1,2,3,4,5,6,7,8,9] (Zero padded strings are converted to
integers automatically)

    range("a", "c")

Will return: ["a","b","c"]

    range("host01", "host10")

Will return: ["host01", "host02", ..., "host09", "host10"]


- *Type*: rvalue

realize
-------
Make a virtual object real.  This is useful
when you want to know the name of the virtual object and don't want to
bother with a full collection.  It is slightly faster than a collection,
and, of course, is a bit shorter.  You must pass the object using a
reference; e.g.: `realize User[luke]`.

- *Type*: statement

regsubst
--------
Perform regexp replacement on a string or array of strings.

* *Parameters* (in order):
    * _target_  The string or array of strings to operate on.  If an array, the replacement will be performed on each of the elements in the array, and the return value will be an array.
    * _regexp_  The regular expression matching the target string.  If you want it anchored at the start and or end of the string, you must do that with ^ and $ yourself.
    * _replacement_  Replacement string. Can contain backreferences to what was matched using \0 (whole match), \1 (first set of parentheses), and so on.
    * _flags_  Optional. String of single letter flags for how the regexp is interpreted:
        - *E*         Extended regexps
        - *I*         Ignore case in regexps
        - *M*         Multiline regexps
        - *G*         Global replacement; all occurrences of the regexp in each target string will be replaced.  Without this, only the first occurrence will be replaced.
    * _encoding_  Optional.  How to handle multibyte characters.  A single-character string with the following values:
        - *N*         None
        - *E*         EUC
        - *S*         SJIS
        - *U*         UTF-8

* *Examples*

Get the third octet from the node's IP address:

    $i3 = regsubst($ipaddress,'^(\d+)\.(\d+)\.(\d+)\.(\d+)$','\3')

Put angle brackets around each octet in the node's IP address:

    $x = regsubst($ipaddress, '([0-9]+)', '<\1>', 'G')


- *Type*: rvalue

require
-------
Evaluate one or more classes,  adding the required class as a dependency.

The relationship metaparameters work well for specifying relationships
between individual resources, but they can be clumsy for specifying
relationships between classes.  This function is a superset of the
'include' function, adding a class relationship so that the requiring
class depends on the required class.

Warning: using require in place of include can lead to unwanted dependency cycles.

For instance the following manifest, with 'require' instead of 'include' would produce a nasty dependence cycle, because notify imposes a before between File[/foo] and Service[foo]:

    class myservice {
      service { foo: ensure => running }
    }

    class otherstuff {
      include myservice
      file { '/foo': notify => Service[foo] }
    }

Note that this function only works with clients 0.25 and later, and it will
fail if used with earlier clients.



- *Type*: statement

reverse
-------
Reverses the order of a string or array.


- *Type*: rvalue

rstrip
------
Strips leading spaces to the right of the string.


- *Type*: rvalue

search
------
Add another namespace for this class to search.
This allows you to create classes with sets of definitions and add
those classes to another class's search path.

- *Type*: statement

sha1
----
Returns a SHA1 hash value from a provided string.

- *Type*: rvalue

shellquote
----------
Quote and concatenate arguments for use in Bourne shell.

Each argument is quoted separately, and then all are concatenated
shuffle
-------
Randomizes the order of a string or array elements.


- *Type*: rvalue

size
----
Returns the number of elements in a string or array.


- *Type*: rvalue

sort
----
Sorts strings and arrays lexically.


- *Type*: rvalue

squeeze
-------
Returns a new string where runs of the same character that occur in this set are replaced by a single character.


- *Type*: rvalue

str2bool
--------
This converts a string to a boolean. This attempt to convert strings that 
contain things like: y, 1, t, true to 'true' and strings that contain things
like: 0, f, n, false, no to 'false'.


- *Type*: rvalue

str2saltedsha512
----------------
This converts a string to a salted-SHA512 password hash (which is used for
OS X versions >= 10.7). Given any simple string, you will get a hex version
of a salted-SHA512 password hash that can be inserted into your Puppet
manifests as a valid password attribute.


- *Type*: rvalue

strftime
--------
This function returns formatted time.

*Examples:*

To return the time since epoch:

    strftime("%s")

To return the date:

    strftime("%Y-%m-%d")

*Format meaning:*

    %a - The abbreviated weekday name (``Sun'')
    %A - The  full  weekday  name (``Sunday'')
    %b - The abbreviated month name (``Jan'')
    %B - The  full  month  name (``January'')
    %c - The preferred local date and time representation
    %C - Century (20 in 2009)
    %d - Day of the month (01..31)
    %D - Date (%m/%d/%y)
    %e - Day of the month, blank-padded ( 1..31)
    %F - Equivalent to %Y-%m-%d (the ISO 8601 date format)
    %h - Equivalent to %b
    %H - Hour of the day, 24-hour clock (00..23)
    %I - Hour of the day, 12-hour clock (01..12)
    %j - Day of the year (001..366)
    %k - hour, 24-hour clock, blank-padded ( 0..23)
    %l - hour, 12-hour clock, blank-padded ( 0..12)
    %L - Millisecond of the second (000..999)
    %m - Month of the year (01..12)
    %M - Minute of the hour (00..59)
    %n - Newline (
)
    %N - Fractional seconds digits, default is 9 digits (nanosecond)
            %3N  millisecond (3 digits)
            %6N  microsecond (6 digits)
            %9N  nanosecond (9 digits)
    %p - Meridian indicator (``AM''  or  ``PM'')
    %P - Meridian indicator (``am''  or  ``pm'')
    %r - time, 12-hour (same as %I:%M:%S %p)
    %R - time, 24-hour (%H:%M)
    %s - Number of seconds since 1970-01-01 00:00:00 UTC.
    %S - Second of the minute (00..60)
    %t - Tab character (  )
    %T - time, 24-hour (%H:%M:%S)
    %u - Day of the week as a decimal, Monday being 1. (1..7)
    %U - Week  number  of the current year,
            starting with the first Sunday as the first
            day of the first week (00..53)
    %v - VMS date (%e-%b-%Y)
    %V - Week number of year according to ISO 8601 (01..53)
    %W - Week  number  of the current year,
            starting with the first Monday as the first
            day of the first week (00..53)
    %w - Day of the week (Sunday is 0, 0..6)
    %x - Preferred representation for the date alone, no time
    %X - Preferred representation for the time alone, no date
    %y - Year without a century (00..99)
    %Y - Year with century
    %z - Time zone as  hour offset from UTC (e.g. +0900)
    %Z - Time zone name
    %% - Literal ``%'' character


- *Type*: rvalue

strip
-----
This function removes leading and trailing whitespace from a string or from
every string inside an array.

*Examples:*

    strip("    aaa   ")

Would result in: "aaa"


- *Type*: rvalue

swapcase
--------
This function will swap the existing case of a string.

*Examples:*

    swapcase("aBcD")

Would result in: "AbCd"


- *Type*: rvalue

time
----
This function will return the current time since epoch as an integer.

*Examples:*

    time()

Will return something like: 1311972653


- *Type*: rvalue

to_bytes
--------
Converts the argument into bytes, for example 4 kB becomes 4096.
Takes a single string value as an argument.


- *Type*: rvalue

type
----
Returns the type when passed a variable. Type can be one of:

* string
* array
* hash
* float
* integer
* boolean


- *Type*: rvalue

unique
------
This function will remove duplicates from strings and arrays.

*Examples:*

    unique("aabbcc")

Will return:

    abc

You can also use this with arrays:

    unique(["a","a","b","b","c","c"])

This returns:

    ["a","b","c"]


- *Type*: rvalue

upcase
------
Converts a string or an array of strings to uppercase.

*Examples:*

    upcase("abcd")

Will return:

    ASDF


- *Type*: rvalue

validate_absolute_path
----------------------
Validate the string represents an absolute path in the filesystem.  This function works
for windows and unix style paths.

The following values will pass:

    $my_path = "C:/Program Files (x86)/Puppet Labs/Puppet"
    validate_absolute_path($my_path)
    $my_path2 = "/var/lib/puppet"
    validate_absolute_path($my_path2)


The following values will fail, causing compilation to abort:

    validate_absolute_path(true)
    validate_absolute_path([ 'var/lib/puppet', '/var/foo' ])
    validate_absolute_path([ '/var/lib/puppet', 'var/foo' ])
    $undefined = undef
    validate_absolute_path($undefined)



- *Type*: statement

validate_array
--------------
Validate that all passed values are array data structures. Abort catalog
compilation if any value fails this check.

The following values will pass:

    $my_array = [ 'one', 'two' ]
    validate_array($my_array)

The following values will fail, causing compilation to abort:

    validate_array(true)
    validate_array('some_string')
    $undefined = undef
    validate_array($undefined)



- *Type*: statement

validate_bool
-------------
Validate that all passed values are either true or false. Abort catalog
compilation if any value fails this check.

The following values will pass:

    $iamtrue = true
    validate_bool(true)
    validate_bool(true, true, false, $iamtrue)

The following values will fail, causing compilation to abort:

    $some_array = [ true ]
    validate_bool("false")
    validate_bool("true")
    validate_bool($some_array)



- *Type*: statement

validate_hash
-------------
Validate that all passed values are hash data structures. Abort catalog
compilation if any value fails this check.

The following values will pass:

    $my_hash = { 'one' => 'two' }
    validate_hash($my_hash)

The following values will fail, causing compilation to abort:

    validate_hash(true)
    validate_hash('some_string')
    $undefined = undef
    validate_hash($undefined)



- *Type*: statement

validate_re
-----------
Perform simple validation of a string against one or more regular
expressions. The first argument of this function should be a string to
test, and the second argument should be a stringified regular expression
(without the // delimiters) or an array of regular expressions.  If none
of the regular expressions match the string passed in, compilation will
abort with a parse error.

If a third argument is specified, this will be the error message raised and
seen by the user.

The following strings will validate against the regular expressions:

    validate_re('one', '^one$')
    validate_re('one', [ '^one', '^two' ])

The following strings will fail to validate, causing compilation to abort:

    validate_re('one', [ '^two', '^three' ])

A helpful error message can be returned like this:

    validate_re($::puppetversion, '^2.7', 'The $puppetversion fact value does not match 2.7')



- *Type*: statement

validate_slength
----------------
Validate that the first argument is a string (or an array of strings), and
less/equal to than the length of the second argument.  It fails if the first
argument is not a string or array of strings, and if arg 2 is not convertable
to a number.

The following values will pass:

  validate_slength("discombobulate",17)
  validate_slength(["discombobulate","moo"],17)

The following valueis will not:

  validate_slength("discombobulate",1)
  validate_slength(["discombobulate","thermometer"],5)



- *Type*: statement

validate_string
---------------
Validate that all passed values are string data structures. Abort catalog
compilation if any value fails this check.

The following values will pass:

    $my_string = "one two"
    validate_string($my_string, 'three')

The following values will fail, causing compilation to abort:

    validate_string(true)
    validate_string([ 'some', 'array' ])
    $undefined = undef
    validate_string($undefined)



- *Type*: statement

values
------
When given a hash this function will return the values of that hash.

*Examples:*

    $hash = {
      'a' => 1,
      'b' => 2,
      'c' => 3,
    }
    values($hash)

This example would return:

    [1,2,3]


- *Type*: rvalue

values_at
---------
Finds value inside an array based on location.

The first argument is the array you want to analyze, and the second element can
be a combination of:

* A single numeric index
* A range in the form of 'start-stop' (eg. 4-9)
* An array combining the above

*Examples*:

    values_at(['a','b','c'], 2)

Would return ['c'].

    values_at(['a','b','c'], ["0-1"])

Would return ['a','b'].

    values_at(['a','b','c','d','e'], [0, "2-3"])

Would return ['a','c','d'].


- *Type*: rvalue

zip
---
Takes one element from first array and merges corresponding elements from second array. This generates a sequence of n-element arrays, where n is one more than the count of arguments.

*Example:*

    zip(['1','2','3'],['4','5','6'])

Would result in:

    ["1", "4"], ["2", "5"], ["3", "6"]


- *Type*: rvalue



----------------

*This page autogenerated on Thu Aug 16 10:53:05 -0700 2012*

