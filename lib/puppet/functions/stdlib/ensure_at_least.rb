# @summary
#   Return the package version for a given package that is at least the given minimum version
#   The function will compare the currently installed package with the given minimum version and:
#    - return the minimum version if the installed package is less than the minimum version, or not present
#    - return the installed version if the installed package is the same or newer than the minimum version
#   If the optional 'installversion' parameter is set, a different version than the minimum version can be returned
#
# @example Example usage:
#   # Ensure at least version 2.7.5-77.el7_6 of python is installed
#     package { 'python':
#       ensure => ensure_at_least('python', '2.7.5-77.el7_6')
#     }
#
# @example To install the latest version if the minimum version is not met:
#   # Ensure the latest version of python is installed if it is not at least version 2.7.5-77.el7_6
#     package { 'python':
#       ensure => ensure_at_least('python', '2.7.5-77.el7_6', 'latest')
#     }
#
# @example To specify a specific provider, you also have to provide a value for 'installversion':
#   # Ensure at least version 2.1.2 of the openssl gem is installed
#     package { 'openssl':
#       ensure   => ensure_at_least('openssl', '2.1.2', '2.1.2', 'gem'),
#       provider => gem
#     }
#
# @example To specify all options:
#   # Ensure the latest version of the openssl gem is installed if it is not at least version 2.1.2
#     package { 'openssl':
#       ensure   => ensure_at_least('openssl', '2.1.2', 'latest', 'gem'),
#       provider => gem
#     }
#
Puppet::Functions.create_function(:ensure_at_least) do
  # @param package
  #   The package to ensure
  #
  # @param minversion
  #   The minimum version to ensure
  #
  # @param installversion
  #   (Optional) The version to install if the minimum is higher than installed (when you want to install a different version than the minversion)
  #
  # @param provider
  #   (Optional) The provider to use for comparing packages
  #
  # @return [String] package version value.
  dispatch :ensure_at_least do
    required_param 'String', :package
    required_param 'String', :minversion
    optional_param 'String', :installversion
    optional_param 'String', :provider
    return_type 'String'
  end

  def ensure_at_least(package, minversion, installversion = nil, provider = nil)
    # Define default behavior
    def_providers = {
      'aix'          => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'aix'     },
      'amazon'       => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'yum'     },
      'archlinux'    => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'pacman'  },
      'darwin'       => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'pkgdmg'  },
      'debian'       => { 'filter' => false, 'type' => 'osfamily',        'provider' => 'apt'     },
      'dragonfly'    => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'pkgng'   },
      'fedora'       => { 'filter' => true,  'type' => 'operatingsystem', 'fact' => 'operatingsystemmajrelease', 'provider' => [
        { 'version' => (19..21).to_a.map(&:to_s), 'provider' => 'yum' },
        { 'version' => ['default'], 'provider' => 'dnf' },
      ] },
      'freebsd'      => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'pkgng'   },
      'gentoo'       => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'portage' },
      'redhat'       => { 'filter' => true, 'type' => 'osfamily', 'fact' => 'operatingsystemmajrelease', 'provider' => [
        { 'version' => (1..3).to_a.map(&:to_s), 'provider' => 'up2date' },
        { 'version' => (4..7).to_a.map(&:to_s), 'provider' => 'yum' },
        { 'version' => ['default'], 'provider' => 'dnf' },
      ] },
      'hp-ux'        => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'hpux'    },
      'mandriva'     => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'urpmi'   },
      'mandrake'     => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'urpmi'   },
      'manjarolinux' => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'pacman'  },
      'netbsd'       => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'pkgin'   },
      'photonos'     => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'tdnf'    },
      'openbsd'      => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'openbsd' },
      'openwrt'      => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'opkg'    },
      'smartos'      => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'pkgin'   },
      'solaris'      => { 'filter' => true, 'type' => 'osfamily', 'fact' => 'kernelrelease', 'provider' => [
        { 'version' => ['5.10'],         'provider' => 'sun' },
        { 'version' => ['5.11', '5.12'], 'provider' => 'pkg' },
        { 'version' => ['default'],      'provider' => 'pkg' },
      ] },
      'suse'         => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'zypper'  },
      'sles'         => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'zypper'  },
      'sled'         => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'zypper'  },
      'opensuse'     => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'zypper'  },
      'windows'      => { 'filter' => false, 'type' => 'operatingsystem', 'provider' => 'windows' },
    }

    # Get trusted facts so we can query the certname
    trusted = closure_scope['trusted']
    query = [
      'package_inventory[version,provider] {',
      "certname = '#{trusted['certname']}'",
      "and package_name = '#{package}'",
      ("and provider = '#{provider}'" unless provider.nil?), # If a provider was specified, filter on it
      '}',
    ].compact.join(' ')

    # Define core message prefix
    msgprefix = "stdlib::ensure_at_least | Node: #{trusted['certname']} | Package: #{package} |"

    # Query PuppetDB's Package Inventory for matching packages
    queryresult = call_function('puppetdb_query', query)
    # Behavior needs to be dependent on the query's results
    case queryresult.length
    when 0
      # No packages were found for this package or package/provider-combo; return no installed version
      result = { 'version' => '' }
    when 1
      # Exactly one result was found, return this version if it matches the given provider or if no provider was specified
      if provider.nil? || queryresult.first['provider'] == provider
        result = queryresult.first
        provider = result['provider']
      else
        result = { 'version' => '' }
      end
    when 2..Float::INFINITY
      # Multiple results were found, which could have multiple causes that we have to test for
      # First, determine if we got multiple records for the same provider, or multiple providers
      if queryresult.uniq { |e| e['provider'] }.length == 1
        # All the records are for the same provider, so select it if it matches the given provider or if no provider was specified
        if provider.nil? || queryresult.first['provider'] == provider
          provider = queryresult.uniq { |e| e['provider'] }.first['provider']
        else
          result = { 'version' => '' }
        end
      elsif provider.nil?
        # If we make it to here, we have this situation:
        #   - Multiple PuppetDB records were returned by the query
        #   - These records are coming from >1 providers
        #   - There could be >1 record for each provider
        #   - No specific provider was given in the function call, so we have to pick one
        call_function('notice', "#{msgprefix} Multiple Package Inventory results found and no provider given, attempting to auto-select provider")
        # First, get all facts so we can query the node's OS
        facts = closure_scope['facts']
        # Iterate through the def_providers array and see if our node matches one based on OS or OS family
        def_providers.each do |os, data|
          blnos = (data['type'] == 'operatingsystem' && os == facts['operatingsystem'].downcase)
          blnosfamily = (data['type'] == 'osfamily' && os == facts['osfamily'].downcase)
          next unless blnos || blnosfamily

          # Found a def_providers match for this OS/OS Family
          call_function('notice', "#{msgprefix} Auto-selecting for #{data['type']} #{os}")
          # Check if this OS (family) uses a different provider dependent on the specific OS version
          unless data['filter'] == true
            # The provider is generic for this OS
            provider = data['provider']
            break
          end
          # The provider to select is dependent on the specific OS version
          found = false
          def_provider = nil
          # Iterate through each OS version-specific provider to find a match
          data['provider'].each do |item|
            if item['version'].include? facts[data['fact']]
              # Found a match, use this one and exit the loop
              found = true
              provider = item['provider']
              break
            elsif item['version'].include? 'default'
              # Found a default option, store it for later use
              def_provider = item['provider']
            end
          end
          # Use the default provided we didn't find a version-specific match
          provider = def_provider unless found && def_provider.nil?
          # No need to parse the rest of the def_providers hash as we already found a match
          break
        end
      end
      call_function('notice', "#{msgprefix} Auto-selected provider #{provider}")
      msgprefix = "#{msgprefix} Provider #{provider} |"
      providerselected = true
      # Provider is now known or auto-selected, filter the resultset on that provider
      filtered_result = queryresult.select { |elem| elem['provider'] == provider }
      # Now determine how many records we have left
      case filtered_result.length
      when 0
        result = { 'version' => '' }
        call_function('notice', "#{msgprefix} No packages found")
      when 1
        result = filtered_result.first
        call_function('notice', "#{msgprefix} Found version #{result['version']}")
      when 2..Float::INFINITY
        # We found multiple versions for this package, need to recursively compare them to find the highest version
        call_function('notice', "#{msgprefix} Found multiple versions, auto-selecting highest")
        highest = ''
        filtered_result.each do |item|
          case call_function('versioncmp', item['version'], highest)
          when 0, 1
            highest = item['version']
          else
            highest = highest
          end
        end
        result = { 'version' => highest }
        call_function('notice', "#{msgprefix} Auto-selected highest version #{highest}")
      else
        result = { 'version' => '' }
        call_function('notice', "#{msgprefix} Error occured finding packages")
      end
    else
      result = { 'version' => '' }
      call_function('notice', "#{msgprefix}#{" Provider #{provider} |" unless provider.nil?} Error occured finding packages")
    end

    msgprefix = "#{msgprefix}#{" Provider #{provider} |" unless provider.nil?}" unless providerselected
    installed = result['version']

    case call_function('versioncmp', installed, minversion)
    when 0, 1
      call_function('notice', "#{msgprefix} Returned installed version #{installed}, reason: newer or same as minimum version #{minversion}")
      return installed
    else
      retversion = if installversion.nil?
                     minversion
                   else
                     installversion
                   end
      call_function('notice', "#{msgprefix} Returned version to install: #{retversion}, reason: minimum version #{minversion} not present")
      return retversion
    end
  end
end
