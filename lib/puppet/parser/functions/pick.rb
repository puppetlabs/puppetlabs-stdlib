#
# pick.rb
#
module Puppet::Parser::Functions
  newfunction(:pick, :type => :rvalue, :doc => <<-DOC
    This function is similar to a coalesce function in SQL in that it will return
    the first value in a list of values that is not undefined or an empty string
    (two things in Puppet that will return a boolean false value). Typically,
    this function is used to check for a value in the Puppet Dashboard/Enterprise
    Console, and failover to a default value like the following:

      $real_jenkins_version = pick($::jenkins_version, '1.449')

    The value of $real_jenkins_version will first look for a top-scope variable
    called 'jenkins_version' (note that parameters set in the Puppet Dashboard/
    Enterprise Console are brought into Puppet as top-scope variables), and,
    failing that, will use a default value of 1.449.

    If you have `strict_variables` turned on, then wrap your variable in single
    quotes to prevent interpolation and this function will check to see if that
    variable exists.

      $real_jenkins_version = pick('$::jenkins_version', '1.449')

DOC
             ) do |args|
    # look up the values of any strings that look like '$variables' w/o mutating args
    args = args.map do |item|
      next item unless item.is_a? String
      item.start_with?('$') ? call_function('getvar', [item.slice(1..-1)]) : item
    end
    args.compact!
    args.delete(:undef)
    args.delete(:undefined)
    args.delete('')
    raise Puppet::ParseError, 'pick(): must receive at least one non empty value' if args[0].to_s.empty?
    return args[0]
  end
end
