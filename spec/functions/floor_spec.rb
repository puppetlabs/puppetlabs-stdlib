# frozen_string_literal: true

require 'spec_helper'

describe 'floor', if: Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params('foo').and_raise_error(Puppet::ParseError, %r{Wrong argument type}) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{Wrong argument type}) }

  it { is_expected.to run.with_params(34).and_return(34) }
  it { is_expected.to run.with_params(-34).and_return(-34) }
  it { is_expected.to run.with_params(33.1).and_return(33) }
  it { is_expected.to run.with_params(-33.1).and_return(-34) }
end
