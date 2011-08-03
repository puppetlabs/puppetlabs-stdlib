#
# kwalify.rb
#

module Puppet::Parser::Functions
  newfunction(:kwalify, :type => :statement, :doc => <<-EOS
This function uses kwalify to validate Puppet data structures against Kwalify
schemas.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "kwalify(): Wrong number of arguments " +
      "given (#{args.size} for 2)") if args.size != 2

    schema = args[0]
    document = args[1]

    require 'kwalify'

    validator = Kwalify::Validator.new(schema)

    errors = validator.validate(document)

    if errors && !errors.empty?
      error_out = []
      for e in errors
        error_out << "[#{e.path}] #{e.message}"
      end
      raise(Puppet::ParseError, "Failed kwalify schema validation:\n" + error_out.join("\n"))
    end

  end
end

# vim: set ts=2 sw=2 et :
