# frozen_string_literal: true

# @summary
#   Escapes a string so that it can be safely used in a batch shell command line.
#
# >* Note:* that the resulting string should be used unquoted and is not intended for use in double quotes nor in single
# quotes.
Puppet::Functions.create_function(:batch_escape) do
  # @param string
  #   The string to escape
  #
  # @return
  #   An escaped string that can be safely used in a batch command line.
  dispatch :batch_escape do
    param 'Any', :string
  end

  def batch_escape(string)
    result = ''

    string.to_s.chars.each do |char|
      result += case char
                when '"' then '""'
                when '$', '\\' then "\\#{char}"
                else char
                end
    end

    %("#{result}")
  end
end
