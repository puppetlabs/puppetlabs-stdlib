require 'puppetlabs_spec_helper/puppet_spec_helper'

RSpec.configure do |config|

  config.before :each do
    GC.disable
  end

  config.after :each do
    GC.enable
  end
end
