require 'spec_helper'

describe 'stdlib::ip_in_range' do
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'stdlib::ip_in_range' expects 2 arguments, got none}) }
    it { is_expected.to run.with_params('one', 'two', '3').and_raise_error(ArgumentError, %r{'stdlib::ip_in_range' expects 2 arguments, got 3}) }
    it { is_expected.to run.with_params([], []).and_raise_error(ArgumentError, %r{'stdlib::ip_in_range' parameter 'ipaddress' expects a String value, got Array}) }
    it { is_expected.to run.with_params('1.1.1.1', 7).and_raise_error(ArgumentError, %r{'stdlib::ip_in_range' parameter 'range' expects a value of type String or Array, got Integer}) }
  end

  describe 'basic validation inputs' do
    it { is_expected.to run.with_params('192.168.100.12', '192.168.100.0/24').and_return(true) }
    it { is_expected.to run.with_params('192.168.100.12', ['10.10.10.10/24', '192.168.100.0/24']).and_return(true) }
    it { is_expected.to run.with_params('10.10.10.10', '192.168.100.0/24').and_return(false) }
  end
end
