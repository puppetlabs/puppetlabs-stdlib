#
# merge_resource_hash.rb
#

module Puppet::Parser::Functions
  newfunction(:merge_resource_hash, :type => :rvalue, :doc => <<-EOS
    Takes any number of hashes of hashes (in the format fit for create_resources()).
    For each key as hash, merges all subkey values (i.e. resource parameters) into arrays.

    E.g. given these three hashes:

       $h1 = {
         k1 => { p1 => 'v1' },
         k2 => { p1 => ['v211', 'v212'] }
       }

       $h2 = {
         k2 => {
           p1 => 'v213',
           p2 => 'v221'
         }
       }

       $h3 = {
         k2 => {
           p1 => ['v214', 'v215'],
           p3 => 'v231'
         },
       }

    it will produce:

       {
         k1 => {p1 => v1},
         k2 => {
           p1 => [v211, v212, v213, v214, v215],
           p2 => v221,
           p3 => v231
         }
       }
  EOS
  ) do |args|
      raise(Puppet::ParseError, "merge_resource_hash(): Wrong number of arguments given (#{args.size})") if args.size < 1

      args.each do |a|
          raise Puppet::ParseError, 'merge_resource_hash(): arguments should be hashes' unless a.is_a?(Hash)

          a.each do |k, v|
              raise Puppet::ParseError, 'merge_resource_hash(): arguments should be hashes of hashes' unless v.is_a?(Hash)
          end
      end

      h = args.shift

      while new_h = args.shift
          h.merge!(new_h) do |k, v1, v2|
              v1.merge(v2) { |kk, vv1, vv2| [vv1, vv2].flatten }
          end
      end

      h
  end
end
