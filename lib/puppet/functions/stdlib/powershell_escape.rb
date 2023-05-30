# frozen_string_literal: true

# @summary
#   Escapes a string so that it can be safely used in a PowerShell command line.
#
# >* Note:* that the resulting string should be used unquoted and is not intended for use in double quotes nor in single
# quotes.
Puppet::Functions.create_function(:'stdlib::powershell_escape') do
  # @param string
  #   The string to escape
  #
  # @return
  #   An escaped string that can be safely used in a PowerShell command line.
  dispatch :powershell_escape do
    param 'Any', :string
  end

  def powershell_escape(string)
    result = ''

    string.to_s.chars.each do |char|
      result += case char
                when ' ', "'", '`', '|', "\n", '$' then "`#{char}"
                when '"' then '\`"'
                else char
                end
    end

    result
  end
end
