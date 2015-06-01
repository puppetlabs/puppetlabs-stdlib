require 'spec_helper'

describe 'parsejson' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params('', '').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params('["one"').and_raise_error(PSON::ParserError) }
  it { is_expected.to run.with_params('["one", "two", "three"]').and_return(['one', 'two', 'three']) }
end
