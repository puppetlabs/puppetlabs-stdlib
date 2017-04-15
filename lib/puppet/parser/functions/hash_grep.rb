module Puppet::Parser::Functions
  newfunction(:hash_grep, :type => :rvalue, :doc => <<-EOS
This function 'greps' in a hash of hashes.
The first argument is the hash of hashes that is needs to be 'grepped' from.
The second argument is an element in the hash of hashes that is to be grepped.

*Examples:*

    hash_grep({'a'=> {'c' => 2, 'd' => 1},'b'=> {'c'=> 3, 'd'=> 2, 'e' => 5}}, 'c')

Would result in: {'a'=> {'c' => 2 },'b'=> {'c'=> 3 }}

    hash_grep({'a'=> {'c' => 2, 'd' => 1},'b'=> {'c'=> 3, 'd'=> 2, 'e' => 5}}, 'e')

Would result in: {'b'=> {'e'=> 5 }}

    EOS
  ) do |args|

    hash_to_filter = args[0]
    filter = args[1]

    # Auto-create hashes
    # http://stackoverflow.com/questions/170223/hashes-of-hashes-idiom-in-ruby
    filtered_hash = Hash.new(&(p=lambda{|h,k| h[k] = Hash.new(&p)}))

    hash_to_filter.each do |instance, properties|
      properties.each do |property, value|
        if property == filter
          filtered_hash[instance][property] = value
        end # if
      end # 2nd each
    end # 1st each

    return filtered_hash

  end # newfunction
end # module

