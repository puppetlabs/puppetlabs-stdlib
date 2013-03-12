#
# augeas.rb
#

module Puppet::Parser::Functions
  newfunction(:augeas, :type => :rvalue, :doc => <<-EOS
Modifies a string using Augeas.

*Example:*

    augeas("proc        /proc   proc    nodev,noexec,nosuid     0       0\n", 'Fstab.lns', ['rm ./1/opt[3]'])

Would result in:

    "proc        /proc   proc    nodev,noexec     0       0\n"
    EOS
  ) do |arguments|
    unless Puppet.features.augeas?
      raise Puppet::ParseError, ('augeas(): this function requires the augeas feature. See http://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Augeas#Pre-requisites for how to activate it.')
    end

    # Check that 2 arguments have been given ...
    raise(Puppet::ParseError, 'augeas(): Wrong number of arguments ' +
      "given (#{arguments.size} for 3)") if arguments.size != 3

    content = arguments[0]
    lens = arguments[1]
    changes = arguments[2]

    # Check arguments
    raise(Puppet::ParseError, 'augeas(): content must be a string') unless content.is_a?(String)
    raise(Puppet::ParseError, 'augeas(): lens must be a string') unless lens.is_a?(String)
    raise(Puppet::ParseError, 'augeas(): changes must be an array') unless changes.is_a?(Array)

    require 'augeas'
    aug = Augeas::open(nil, nil, Augeas::NO_MODL_AUTOLOAD)
    augeas_version = aug.get('/augeas/version')
    raise(Puppet::ParseError, 'augeas(): requires Augeas 1.0.0 or greater') unless Puppet::Util::Package.versioncmp(augeas_version, '1.0.0') >= 0
    raise(Puppet::ParseError, 'augeas(): requires ruby-augeas 0.5.0 or greater') unless aug.methods.include?('text_store')

    result = nil
    begin
      aug.set('/input', content)
      aug.text_store(lens, '/input', '/store')
      unless aug.match("/augeas/text/store//error").empty?
          error = aug.get("/augeas/text/store//error/message")
          raise Puppet::ParseError, "augeas(): Failed to parse string with lens #{lens}: #{error}"
      end

      # Apply changes
      aug.context = '/store'
      changes.each do |c|
        r = aug.srun(c)
        raise Puppet::ParseError, "augeas(): Failed to apply change to tree" unless r and r[0] >= 0
      end
      unless aug.text_retrieve(lens, '/input', '/store', '/output')
        error = aug.get("/augeas/text/store//error/message")
        raise Puppet::ParseError, "augeas(): Failed to apply changes with lens #{lens}: #{error}"
      end
      result = aug.get("/output")
    ensure
      aug.close
    end
    return result
  end
end

# vim: set ts=2 sw=2 et :
