# frozen_string_literal: true

# @summary
#   Escapes a string so that it can be safely used in a Bourne shell command line.
#
# >* Note:* that the resulting string should be used unquoted and is not intended for use in double quotes nor in single
# quotes.
#
# This function behaves the same as ruby's Shellwords.shellescape() function.
Puppet::Functions.create_function(:'stdlib::shell_escape') do
  # @param string
  #   The string to escape
  #
  # @return
  #   An escaped string that can be safely used in a Bourne shell command line.
  dispatch :shell_escape do
    param 'Any', :string
  end

  def shell_escape(string)
    require 'shellwords'

    Shellwords.shellescape(string.to_s)
  end
end
