#
#  glob.rb
#
module Puppet::Parser::Functions
  newfunction(:glob, :type => :rvalue, :doc => <<-'DOC'
    @summary
      Returns an Array of file entries of a directory or an Array of directories.

    Uses same patterns as Dir#glob

    @example Example Usage:
      $confs = glob(['/etc/**/*.conf', '/opt/**/*.conf'])
    DOC
             ) do |arguments|

    unless arguments.size == 1
      raise(Puppet::ParseError, 'glob(): Wrong number of arguments given ' \
        "(#{arguments.size} for 1)")
    end

    pattern = arguments[0]

    unless pattern.is_a?(String) || pattern.is_a?(Array)
      raise(Puppet::ParseError, 'glob(): Requires either array or string ' \
        'to work')
    end

    Dir.glob(pattern)
  end
end
