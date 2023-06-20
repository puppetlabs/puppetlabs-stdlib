# frozen_string_literal: true

# @summary Compare two Hashes to each other, optionally after applying a block.
#
# Returns -1, 0 or 1, depending on whether the first Hash is smaller, equal or bigger
# than the second Hash. If no block is supplied, both Hashes will be transformed
# into sorted Arrays first. Otherwise, the block has to yield something that Ruby
# can compare with the `<=>` operator.
#
# @example Use stdlib::cmp_hash to sort a list of Hashes (here, the local disks by their volume)
#   $::disks.values.sort |$a, $b| { stdlib::cmp_hash($a, $b) |$h| { $h['size_bytes'] } }
#
Puppet::Functions.create_function(:'stdlib::cmp_hash') do
  # @param hash1 The first Hash.
  # @param hash2 The second Hash.
  # @example Compare by default tranformation to Arrays
  #   $hash1 = {
  #     'primary_key' => 2,
  #     'key1'        => ['val1', 'val2'],
  #     'key2'        => { 'key3' =>  'val3', },
  #     'key4'        => true,
  #     'key5'        => 12345,
  #   }
  #   $hash2 = {
  #     'primary_key' => 1,
  #     'key6'        => ['val1', 'val2'],
  #     'key7'        => { 'key8' =>  'val9', },
  #     'key10'       => true,
  #     'key11'       => 67890,
  #   }
  #   stdlib::cmp_hash($hash1, $hash2) # => -1; 'key1' is the smallest key, thus $hash1 is smaller
  # @return [Integer] Returns an integer (-1, 0, or +1) if hash1 is less than, equal to, or greater than hash2.
  dispatch :cmp_hashes_as_arrays do
    param 'Hash[Any, Any]', :hash1
    param 'Hash[Any, Any]', :hash2
  end

  # @param hash1 The first Hash.
  # @param hash2 The second Hash.
  # @example Compare two Hashes by a specific key
  #   $hash1 = {
  #     'primary_key' => 2,
  #     'key1'        => ['val1', 'val2'],
  #     'key2'        => { 'key3' => 'val3', },
  #     'key4'        => true,
  #     'key5'        => 12345,
  #   }
  #   $hash2 = {
  #     'primary_key' => 1,
  #     'key6'        => ['val1', 'val2'],
  #     'key7'        => { 'key8' => 'val9', },
  #     'key10'       => true,
  #     'key11'       => 67890,
  #   }
  #   stdlib::cmp_hash($hash1, $hash2) |$h| { $h['primary_key'] } # => 1; $hash2 has the smaller value for 'primary_key', hence $hash1 is bigger
  # @return [Integer] Returns an integer (-1, 0, or +1) if block(hash1) is less than, equal to, or greater than block(hash2).
  dispatch :cmp_hashes_with_block do
    param 'Hash[Any, Any]', :hash1
    param 'Hash[Any, Any]', :hash2
    block_param 'Callable[1,1]', :block
  end

  def cmp_hashes_as_arrays(hash1, hash2)
    cmp_hashes_with_block(hash1, hash2) { |h| h.to_a.sort }
  end

  def cmp_hashes_with_block(hash1, hash2)
    yield(hash1) <=> yield(hash2)
  end
end
