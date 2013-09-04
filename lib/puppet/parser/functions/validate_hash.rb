module Puppet::Parser::Functions

  newfunction(:validate_hash, :arity => -2, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all passed values are hash data structures. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $my_hash = { 'one' => 'two' }
        validate_hash($my_hash)

    The following values will fail, causing compilation to abort:

        validate_hash(true)
        validate_hash('some_string')
        $undefined = undef
        validate_hash($undefined)

    ENDHEREDOC

    args.each do |arg|
      unless arg.is_a?(Hash)
        raise Puppet::ParseError, ("#{arg.inspect} is not a Hash.  It looks to be a #{arg.class}")
      end
    end

  end

end
