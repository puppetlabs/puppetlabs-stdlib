# encoding: UTF-8
Puppet::Type.newtype(:remote_file) do

  desc 'Retrieve remote files via http(s)'

  ensurable

  newparam(:source) do
    desc 'Software installation http/https source.'
    newvalues(/https?:\/\//, /\//)
    validate do |value|
      unless Pathname.new(value).absolute? ||
          URI.parse(value).is_a?(URI::HTTP)
        fail("Invalid source #{value}")
      end
    end
  end

  newparam(:checksum) do
    desc 'Specifies whether to check the remote file against a checksum.'
    newvalues(:no, :sha1)
    defaultto :no
  end

  newproperty(:mode) do
    require 'puppet/util/symbolic_file_mode'
    include Puppet::Util::SymbolicFileMode

    desc "Manage the file's mode."

    validate do |value|
      unless value.nil? || valid_symbolic_mode?(value)
        raise Puppet::Error, "The file mode specification is invalid: #{value.inspect}"
      end
    end

    munge do |value|
      return nil if value.nil?

      unless valid_symbolic_mode?(value)
        raise Puppet::Error, "The file mode specification is invalid: #{value.inspect}"
      end

      normalize_symbolic_mode(value)
    end

    defaultto '644'
  end

  newproperty(:owner) do
    desc "Manage the file's owner."

    defaultto 'root'
  end

  newproperty(:group) do
    desc "Manage the file's group."

    defaultto 'root'
  end

  newparam(:path, :namevar => true) do
    desc "Destination path"
    validate do |value|
      unless value =~ /^\/[a-z0-9]+/
        raise ArgumentError , "%s is not a valid file path" % value
      end
    end

  end

  autorequire(:file) do
    self[:source] if self[:source] and Pathname.new(self[:source]).absolute?
  end

end
