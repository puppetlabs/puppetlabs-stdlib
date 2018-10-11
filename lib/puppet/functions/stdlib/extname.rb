# Returns the Extension (the Portion of Filename in Path starting from the
# last Period).
#
# If Path is a Dotfile, or starts with a Period, then the starting Dot is not
# dealt with the Start of the Extension.
#
# An empty String will also be returned, when the Period is the last Character
# in Path.

Puppet::Functions.create_function(:'stdlib::extname') do
  # @param filename The Filename
  # @return [String] The Extension starting from the last Period
  # @example Determining the Extension of a Filename
  #   stdlib::extname('test.rb')       => '.rb'
  #   stdlib::extname('a/b/d/test.rb') => '.rb'
  #   stdlib::extname('test')          => ''
  #   stdlib::extname('.profile')      => ''
  dispatch :extname do
    param 'String', :filename
    return_type 'String'
  end

  def extname(filename)
    File.extname(filename)
  end
end
