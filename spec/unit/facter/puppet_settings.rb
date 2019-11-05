require 'spec_helper'
compat = {
  :vardir => '/dev/null',
  :server => 'puppet',
  # im not sure how to predict this value
  # environmentpath: '/tmp/environmentsfoobar',
}
# not sure how best to predict theses?
# settings = {
#   :vardir => '/dev/null',
#   :server => 'puppet',
#   :localcacert => '/dev/null',
#   :ssldir => '/dev/null',
#   :hostpubkey => '/dev/null',
#   :hostprivkey => '/dev/null',
#   :hostcert => '/dev/null',
#   :environmentpath => '/tmp/environmentsfoobar',
# }

describe 'puppet_settings' do
  context 'when puppet' do
    compat.each_pair do |setting, value|
      it "puppet_#{setting} is #{value}" do
        expect(Facter.fact("puppet_#{setting}".to_sym).value).to eq(value)
      end
    end
    # it 'puppet_settings' do
    #  expect(Facter.fact(:puppet_settings).value).to eq(settings)
    # end
  end
end
