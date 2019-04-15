# @summary
#   Merges two or more hashes together or hashes resulting from iteration, and returns
#   the resulting hash.
#
# @example Using merge()
#   $hash1 = {'one' => 1, 'two', => 2}
#   $hash2 = {'two' => 'dos', 'three', => 'tres'}
#   $merged_hash = merge($hash1, $hash2) # $merged_hash =  {'one' => 1, 'two' => 'dos', 'three' => 'tres'}
#
# When there is a duplicate key, the key in the rightmost hash will "win."
#
# Note that since Puppet 4.0.0 the same merge can be achieved with the + operator.
#  `$merged_hash = $hash1 + $hash2`
#
# If merge is given a single Iterable (Array, Hash, etc.) it will call a given block with
# up to three parameters, and merge each resulting Hash into the accumulated result. All other types
# of values returned from the block (typically undef) are skipped (not merged).
#
# The codeblock can take 2 or three parameters:
# * with two, it gets the current hash (as built to this point), and each value (for hash the value is a [key, value] tuple)
# * with three, it gets the current hash (as built to this point), the key/index of each value, and then the value
#
# If the iterable is empty, or no hash was returned from the given block, an empty hash is returned. In the given block, a call to `next()`
# will skip that entry, and a call to `break()` will end the iteration.
#
# @example counting occurrences of strings in an array
#   ['a', 'b', 'c', 'c', 'd', 'b'].merge | $hsh, $v | { { $v => $hsh[$v].lest || { 0 } + 1 } } # results in { a => 1, b => 2, c => 2, d => 1 }
#
# @example skipping values for entries that are longer than 1 char
#   ['a', 'b', 'c', 'c', 'd', 'b', 'blah', 'blah'].merge | $hsh, $v | { if $v =~ String[1,1] { { $v => $hsh[$v].lest || { 0 } + 1 } } } # results in { a => 1, b => 2, c => 2, d => 1 }
#
# The iterative `merge()` has an advantage over doing the same with a general `reduce()` in that the constructed hash
# does not have to be copied in each iteration and thus will perform much better with large inputs.
Puppet::Functions.create_function(:merge) do
  # @param args
  #   Repeated Param - The hashes that are to be merged
  #
  # @return
  #   The merged hash
  dispatch :merge2hashes do
    repeated_param 'Variant[Hash, Undef, String[0,0]]', :args # this strange type is backwards compatible
    return_type 'Hash'
  end

  # @param args
  #   Repeated Param - The hashes that are to be merged
  #
  # @param block
  #   A block placed on the repeatable param `args`
  #
  # @return
  #   The merged hash
  dispatch :merge_iterable3 do
    repeated_param 'Iterable', :args
    block_param 'Callable[3,3]', :block
    return_type 'Hash'
  end

  # @param args
  #   Repeated Param - The hashes that are to be merged
  #
  # @param block
  #   A block placed on the repeatable param `args`
  #
  # @return
  #   The merged hash
  dispatch :merge_iterable2 do
    repeated_param 'Iterable', :args
    block_param 'Callable[2,2]', :block
    return_type 'Hash'
  end

  def merge2hashes(*hashes)
    accumulator = {}
    hashes.each { |h| accumulator.merge!(h) if h.is_a?(Hash) }
    accumulator
  end

  def merge_iterable2(iterable)
    accumulator = {}
    enum = Puppet::Pops::Types::Iterable.asserted_iterable(self, iterable)
    enum.each do |v|
      r = yield(accumulator, v)
      accumulator.merge!(r) if r.is_a?(Hash)
    end
    accumulator
  end

  def merge_iterable3(iterable)
    accumulator = {}
    enum = Puppet::Pops::Types::Iterable.asserted_iterable(self, iterable)
    if enum.hash_style?
      enum.each do |entry|
        r = yield(accumulator, *entry)
        accumulator.merge!(r) if r.is_a?(Hash)
      end
    else
      begin
        index = 0
        loop do
          r = yield(accumulator, index, enum.next)
          accumulator.merge!(r) if r.is_a?(Hash)
          index += 1
        end
      rescue StopIteration # rubocop:disable Lint/HandleExceptions
      end
    end
    accumulator
  end
end
