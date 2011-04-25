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

    raise(Puppet::ParseError, "fact(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    fact = arguments[0]

    raise(Puppet::ParseError, 'fact(): You must provide ' +
      'fact name') if fact.empty?

    fact   = strinterp(fact) # Evaluate any interpolated variable names ...
    result = lookupvar(fact) # Get the value of interest from Facter ...

    if not result or result.empty?
      #
      # Now this is a funny one ...  Puppet does not have a concept of
      # returning neither undef nor nil back for use within the Puppet DSL
      # and empty string is as closest to actual undef as you we can get
      # at this point in time ...
      #
      result = ''
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
