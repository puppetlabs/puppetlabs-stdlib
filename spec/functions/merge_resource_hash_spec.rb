require 'spec_helper'

describe 'merge_resource_hash' do
  let(:h1) { {
      'foo' => { 'p1' => ['v1', 'v2'] },
      'bar' => { 'p' => 'v' }
  } }

  let(:h2) { {
      'foo' => {
          'p1' => 'v3',
          'p2' => ['v1', 'v2'],
      },
  } }

  let(:h3) { {
      'foo' => {
          'p2' => ['v3'],
      },
      'baz' => {
          'p' => 'v',
      },
  } }

  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /Wrong number of arguments/) }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, /arguments should be hashes/) }
  it { is_expected.to run.with_params('a').and_raise_error(Puppet::ParseError, /arguments should be hashes/) }
  it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, /arguments should be hashes/) }
  it { is_expected.to run.with_params({'a' => 'b'}).and_raise_error(Puppet::ParseError, /arguments should be hashes of hashes/i) }

  it { is_expected.to run.with_params(h1).and_return(h1) }
  it { is_expected.to run.with_params(h1, h2).and_return({
      'foo' => {
          'p1' => ['v1', 'v2', 'v3'],
          'p2' => ['v1', 'v2'],
      },
      'bar' => { 'p' => 'v' },
  }) }
  it { is_expected.to run.with_params(h1, h2, h3).and_return({
      'foo' => {
          'p1' => ['v1', 'v2', 'v3'],
          'p2' => ['v1', 'v2', 'v3'],
      },
      'bar' => { 'p' => 'v' },
      'baz' => { 'p' => 'v' },
  }) }
end
