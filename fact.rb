#
# fact.rb
#

module Puppet::Parser::Functions
  newfunction(:fact, :type => :rvalue, :doc => <<-EOS
This function will retrieve fact from Facter based on the fact
name and expose it for further use within Puppet manifest file ...

For example:

Given the following sample manifest:

   define partitions {
     $result = split(fact("partitions_${name}"), ',')

     notice $result

     partition { $result: }
   }

   define partition {
     notice $name
   }

   $available_disks = split($disks, ',')

   partitions { $available_disks: }

This will produce the following:

   notice: Scope(Partitions[hda]): hda1 hda2
   notice: Scope(Partition[hda1]): hda1
   notice: Scope(Partition[hda2]): hda2


Which allows you to avoid resorting to the following:

   $fact   = "partitions_${name}"
   $result = split(inline_template("<%= scope.lookupvar(fact) %>"), ',')

Phasing out the need for use and abuse of the infamous inline_template in the
partitions define given above.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    fact = arguments[0]

    raise(Puppet::ParseError, 'You must provide fact name') if fact.empty?

    result = lookupvar(fact) # Get the value of interest from Facter ...

    if not result or result.empty?
      raise(Puppet::ParseError, "Unable to retrieve fact `#{fact}'")
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
