# frozen_string_literal: true

# @summary Sort an Array, Hash or String by mapping values through a given block.
#
# @example Sort local devices according to their used space.
#   $facts['mountpoints'].stdlib::sort_by |$m| { $m.dig(1, 'used_bytes') }
#
Puppet::Functions.create_function(:'stdlib::sort_by') do
  # @param ary The Array to sort.
  # @param block The block for transforming elements of ary.
  # @return [Array] Returns an ordered copy of ary.
  dispatch :sort_by_array do
    param 'Array', :ary
    block_param 'Callable[1,1]', :block
  end

  # @param str The String to sort.
  # @param block The block for transforming elements of str.
  # @return [String] Returns an ordered copy of str.
  dispatch :sort_by_string do
    param 'String', :str
    block_param 'Callable[1,1]', :block
  end

  # @param hsh The Hash to sort.
  # @param block The block for transforming elements of hsh.
  #              The block may have arity of one or two.
  # @return [Hash] Returns an ordered copy of hsh.
  dispatch :sort_by_hash do
    param 'Hash', :hsh
    block_param 'Variant[Callable[1,1], Callable[2,2]]', :block
  end

  def sort_by_iterable(iterable, &block)
    Puppet::Pops::Types::Iterable.asserted_iterable(self, iterable).sort_by(&block)
  end

  def sort_by_array(ary, &block)
    sort_by_iterable(ary, &block)
  end

  def sort_by_string(str, &block)
    sort_by_iterable(str, &block).join
  end

  def sort_by_hash(hsh, &block)
    sort_by_iterable(hsh, &block).to_h
  end
end
