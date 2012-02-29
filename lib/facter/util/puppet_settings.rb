module Facter
  module Util
    module PuppetSettings
      class << self
        def with_puppet
          begin
            Module.const_get("Puppet")
          rescue NameError
            nil
          else
            yield
          end
        end
      end
    end
  end
end
