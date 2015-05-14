Puppet::Type.newtype(:file_line) do

  desc <<-EOT
    Ensures that a given line is contained within a file.  The implementation
    matches the full line, including whitespace at the beginning and end.  If
    the line is not contained in the given file, Puppet will append the line to
    the end of the file to ensure the desired state.  Multiple resources may 
    be declared to manage multiple lines in the same file.

    Example:

        file_line { 'sudo_rule':
          path => '/etc/sudoers',
          line => '%sudo ALL=(ALL) ALL',
        }

        file_line { 'sudo_rule_nopw':
          path => '/etc/sudoers',
          line => '%sudonopw ALL=(ALL) NOPASSWD: ALL',
        }

    In this example, Puppet will ensure both of the specified lines are
    contained in the file /etc/sudoers.

    Match Example:

        file_line { 'bashrc_proxy':
          ensure => present,
          path   => '/etc/bashrc',
          line   => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
          match  => '^export\ HTTP_PROXY\=',
        }

    In this code example match will look for a line beginning with export 
    followed by HTTP_PROXY and replace it with the value in line.

    **Autorequires:** If Puppet is managing the file that will contain the line
    being managed, the file_line resource will autorequire that file.

  EOT

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newparam(:match) do
    desc 'An optional ruby regular expression to run against existing lines in the file.' + 
         ' If a match is found, we replace that line rather than adding a new line.' +
         ' A regex comparisson is performed against the line value and if it does not' +
         ' match an exception will be raised. '
  end

  newparam(:multiple) do
    desc 'An optional value to determine if match can change multiple lines.' +
         ' If set to false, an exception will be raised if more than one line matches'
    newvalues(true, false)
  end

  newparam(:after) do
    desc 'An optional value used to specify the line after which we will add any new lines. (Existing lines are added in place)'
  end

  newparam(:line) do
    desc 'The line to be appended to the file or used to replace matches found by the match attribute.'
  end

  newparam(:path) do
    desc 'The file Puppet will ensure contains the line specified by the line parameter.'
    validate do |value|
      # This logic was borrowed from
      # [lib/puppet/file_serving/base.rb](https://github.com/puppetlabs/puppet/blob/master/lib/puppet/file_serving/base.rb)

      # Puppet 2.7 and beyond will have Puppet::Util.absolute_path?  Fall back to a back-ported implementation otherwise.
      if Puppet::Util.respond_to?(:absolute_path?) then
        unless Puppet::Util.absolute_path?(value, :posix) or Puppet::Util.absolute_path?(value, :windows)
          raise Puppet::Error, ("File paths must be fully qualified, not '#{value}'")
        end
      else
        # This code back-ported from 2.7.x's lib/puppet/util.rb Puppet::Util.absolute_path?
        # Determine in a platform-specific way whether a path is absolute. This
        # defaults to the local platform if none is specified.
        # Escape once for the string literal, and once for the regex.
        slash = '[\\\\/]'
        name = '[^\\\\/]+'
        regexes = {
          :windows => %r!^(([A-Z]:#{slash})|(#{slash}#{slash}#{name}#{slash}#{name})|(#{slash}#{slash}\?#{slash}#{name}))!i,
          :posix   => %r!^/!,
        }
        rval = (!!(value =~ regexes[:posix])) || (!!(value =~ regexes[:windows]))
        rval or raise Puppet::Error, ("File paths must be fully qualified, not '#{value}'")
      end
    end
  end

  # Autorequire the file resource if it's being managed
  autorequire(:file) do
    self[:path]
  end

  validate do
    unless self[:line] and self[:path]
      raise(Puppet::Error, "Both line and path are required attributes")
    end
  end
end
