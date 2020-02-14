require 'spec_helper'

describe 'stdlib::end_with' do
  it { is_expected.to run.with_params('foobar', 'bar').and_return(true) }
  it { is_expected.to run.with_params('foobar', 'foo').and_return(false) }
  it { is_expected.to run.with_params('foobar', ['foo', 'baz']).and_return(false) }
  it do
    is_expected.to run.with_params('', 'foo').and_raise_error(
      ArgumentError, %r{'stdlib::end_with' parameter 'test_string' expects a String\[1\] value}
    )
  end
  it do
    is_expected.to run.with_params('foobar', '').and_raise_error(
      ArgumentError, %r{'stdlib::end_with' parameter 'suffixes' expects a value of type String\[1\] or Array\[String\[1\], 1\]}
    )
  end
end
