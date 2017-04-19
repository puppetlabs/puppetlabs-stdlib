require 'spec_helper'

describe 'clientcert_rand' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(ArgumentError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params(1).and_raise_error(ArgumentError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params(0, '').and_raise_error(ArgumentError, /first argument must be a positive integer/) }
  it { is_expected.to run.with_params(1.5, '').and_raise_error(ArgumentError, /first argument must be a positive integer/) }
  it { is_expected.to run.with_params(-10, '').and_raise_error(ArgumentError, /first argument must be a positive integer/) }
  it { is_expected.to run.with_params("-10", '').and_raise_error(ArgumentError, /first argument must be a positive integer/) }
  it { is_expected.to run.with_params("string", '').and_raise_error(ArgumentError, /first argument must be a positive integer/) }
  it { is_expected.to run.with_params([], '').and_raise_error(ArgumentError, /first argument must be a positive integer/) }
  it { is_expected.to run.with_params({}, '').and_raise_error(ArgumentError, /first argument must be a positive integer/) }
  it { is_expected.to run.with_params(1, 1).and_raise_error(ArgumentError, /second argument must be a string/) }
  it { is_expected.to run.with_params(1, []).and_raise_error(ArgumentError, /second argument must be a string/) }
  it { is_expected.to run.with_params(1, {}).and_raise_error(ArgumentError, /second argument must be a string/) }

  it "provides a random number strictly less than the given max" do
    expect(clientcert_rand(3, 'seed')).to satisfy {|n| n.to_i < 3 }
  end

  it "provides a random number greater or equal to zero" do
    expect(clientcert_rand(3, 'seed')).to satisfy {|n| n.to_i >= 0 }
  end

  it "provides the same 'random' value on subsequent calls for the same host" do
    expect(clientcert_rand(10, 'seed')).to eql(clientcert_rand(10, 'seed'))
  end

  it "allows seed to control the random value on a single host" do
    first_random = clientcert_rand(1000, 'seed1')
    second_different_random = clientcert_rand(1000, 'seed2')

    expect(first_random).not_to eql(second_different_random)
  end

  it "should not return different values for different hosts" do
    val1 = clientcert_rand(1000, 'foo', :clientcert => "first.host.com")
    val2 = clientcert_rand(1000, 'foo', :clientcert => "second.host.com")

    expect(val1).to_not eql(val2)
  end

  def clientcert_rand(max, seed, args = {})
    host = args[:clientcert] || '127.0.0.1'

    # workaround not being able to use let(:facts) because some tests need
    # multiple different hostnames in one context
    scope.stubs(:lookupvar).with("::clientcert", {}).returns(clientcert)

    scope.function_clientcert_rand([max, seed])
  end
end
