# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::fqdn_rand_string' do
  let(:default_charset) { %r{\A[a-zA-Z0-9]{100}\z} }

  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{expects at least 1 argument, got none}i) }
  it { is_expected.to run.with_params(0).and_raise_error(ArgumentError, %r{parameter 'length' expects an Integer\[1\] value, got Integer\[0, 0\]}) }
  it { is_expected.to run.with_params(1.5).and_raise_error(ArgumentError, %r{parameter 'length' expects an Integer\ value, got Float}) }
  it { is_expected.to run.with_params(-10).and_raise_error(ArgumentError, %r{parameter 'length' expects an Integer\[1\] value, got Integer\[-10, -10\]}) }
  it { is_expected.to run.with_params('-10').and_raise_error(ArgumentError, %r{parameter 'length' expects an Integer\ value, got String}) }
  it { is_expected.to run.with_params('string').and_raise_error(ArgumentError, %r{parameter 'length' expects an Integer\ value, got String}) }
  it { is_expected.to run.with_params([]).and_raise_error(ArgumentError, %r{parameter 'length' expects an Integer value, got Array}) }
  it { is_expected.to run.with_params({}).and_raise_error(ArgumentError, %r{parameter 'length' expects an Integer value, got Hash}) }
  it { is_expected.to run.with_params(1, 1).and_raise_error(ArgumentError, %r{parameter 'charset' expects a value of type Undef or String, got Integer}) }
  it { is_expected.to run.with_params(1, []).and_raise_error(ArgumentError, %r{parameter 'charset' expects a value of type Undef or String, got Array}) }
  it { is_expected.to run.with_params(1, {}).and_raise_error(ArgumentError, %r{parameter 'charset' expects a value of type Undef or String, got Hash}) }
  it { is_expected.to run.with_params('100').and_raise_error(ArgumentError, %r{parameter 'length' expects an Integer value, got String}) }
  it { is_expected.to run.with_params(100, nil).and_return(default_charset) }
  it { is_expected.to run.with_params(100, '').and_return(default_charset) }
  it { is_expected.to run.with_params(100, nil, 'MY_CUSTOM_SEED').and_return(default_charset) }
  it { is_expected.to run.with_params(100, '', 'MY_CUSTOM_SEED').and_return(default_charset) }
  it { is_expected.to run.with_params(100).and_return(default_charset) }
  it { is_expected.to run.with_params(100, 'a').and_return(%r{\Aa{100}\z}) }
  it { is_expected.to run.with_params(100, 'ab').and_return(%r{\A[ab]{100}\z}) }
  it { is_expected.to run.with_params(100, 'ãβ').and_return(%r{\A[ãβ]{100}\z}) }

  context 'produce predictible and reproducible results' do
    before(:each) do
      if Gem::Version.new(Puppet::PUPPETVERSION) < Gem::Version.new('7.23.0')
        allow(scope).to receive(:lookupvar).with('::fqdn', {}).and_return(fqdn)
      else
        allow(scope).to receive(:lookupvar).with('facts', {}).and_return({ 'networking' => { 'fqdn' => fqdn } })
      end
    end

    context 'on a node named example.com' do
      let(:fqdn) { 'example.com' }

      it { is_expected.to run.with_params(5).and_return('Pw5NP') }
      it { is_expected.to run.with_params(10, 'abcd').and_return('cdadaaacaa') }
      it { is_expected.to run.with_params(20, '', 'custom seed').and_return('3QKQHP4wmEObY3a6hkeg') }
      it { is_expected.to run.with_params(20, '', 'custom seed', 1, 'extra').and_return('OA19SVDoc3QPY5NlSQ28') }
    end

    context 'on a node named desktop-fln40kq.lan' do
      let(:fqdn) { 'desktop-fln40kq.lan' }

      it { is_expected.to run.with_params(5).and_return('bgQsB') }
      it { is_expected.to run.with_params(10, 'abcd').and_return('bcdbcdacad') }
      it { is_expected.to run.with_params(20, '', 'custom seed').and_return('KaZsFlWkUo5SeA3gBEf0') }
      it { is_expected.to run.with_params(20, '', 'custom seed', 1, 'extra').and_return('dcAzn1e8AA7hhoLpxAD6') }
    end
  end
end
