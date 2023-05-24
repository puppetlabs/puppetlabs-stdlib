# frozen_string_literal: true

require 'spec_helper'

describe 'uriescape' do
  # URI.escape has been fully removed as of Ruby 3. Therefore, it will not work as it stand on Puppet 8.
  if Puppet::Util::Package.versioncmp(Puppet.version, '8.0.0').negative?
    describe 'signature validation' do
      it { is_expected.not_to be_nil }
      it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

      it {
        pending('Current implementation ignores parameters after the first.')
        expect(subject).to run.with_params('', '').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
      }

      it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
      it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
      it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
    end

    describe 'handling normal strings' do
      it 'calls ruby\'s URI::DEFAULT_PARSER.escape function' do
        expect(URI::DEFAULT_PARSER).to receive(:escape).with('uri_string').and_return('escaped_uri_string').once
        expect(subject).to run.with_params('uri_string').and_return('escaped_uri_string')
      end
    end

    describe 'handling classes derived from String' do
      it 'calls ruby\'s URI::DEFAULT_PARSER.escape function' do
        uri_string = AlsoString.new('uri_string')
        expect(URI::DEFAULT_PARSER).to receive(:escape).with(uri_string).and_return('escaped_uri_string').once
        expect(subject).to run.with_params(uri_string).and_return('escaped_uri_string')
      end
    end

    describe 'strings in arrays handling' do
      it { is_expected.to run.with_params([]).and_return([]) }
      it { is_expected.to run.with_params(['one}', 'two']).and_return(['one%7D', 'two']) }
      it { is_expected.to run.with_params(['one}', 1, true, {}, 'two']).and_return(['one%7D', 1, true, {}, 'two']) }
    end
  else
    describe 'raising errors in Puppet 8' do
      it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{This function is not available in Puppet 8. URI.escape no longer exists as of Ruby 3+.}) }
    end
  end
end
