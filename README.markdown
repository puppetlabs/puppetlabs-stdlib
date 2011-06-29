## puppetlabs-functions module

### Overview

This is the puppet-functions module. Here we are providing a library of various functions that extend the basic function library that is provided in Puppet.

### Disclaimer

Warning! While this software is written in the best interest of quality it has not been formally tested by our QA teams. Use at your own risk, but feel free to enjoy and perhaps improve it while you do.

Please see the included Apache Software License for more legal details regarding warranty.

### Installation

From github, download the module into your modulepath on your Puppetmaster. If you are not sure where your module path is try this command:

  puppet --configprint modulepath

Depending on the version of Puppet, you may need to restart the puppetmasterd (or Apache) process before the functions will work.

## Functions

### kwalify

This function allows you to validate Puppet data structures using Kwalify 
schemas as documented here:

http://www.kuwata-lab.com/kwalify/ruby/users-guide.01.html

To validate, create a schema in Puppet:

    $schema = {
      'type' => 'seq',
      'sequence' => [
        { 'type' => 'str' }
      ]
    }

And create some content that you want validated:

    $document = ['a', 'b', 'c']

And then use the function to validate:

    kwalify($schema, $document)

The function will throw an error and list all validation errors if there is a
problem otherwise it succeeds silently.
