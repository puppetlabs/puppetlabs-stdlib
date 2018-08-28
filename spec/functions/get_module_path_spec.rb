require 'spec_helper'

describe 'get_module_path' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments, expects one}) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{Wrong number of arguments, expects one}) }
  it { is_expected.to run.with_params('one', 'two', 'three').and_raise_error(Puppet::ParseError, %r{Wrong number of arguments, expects one}) }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, %r{Could not find module}) }

  # class Stubmodule
  class StubModule
    attr_reader :path
    def initialize(path)
      @path = path
    end
  end

  describe 'when locating a module' do
    let(:modulepath) { '/tmp/does_not_exist' }
    let(:path_of_module_foo) { StubModule.new('/tmp/does_not_exist/foo') }

    before(:each) do
      Puppet[:modulepath] = modulepath
    end

    context 'when in the default environment' do
      before(:each) do
        allow(Puppet::Module).to receive(:find).with('foo', 'rp_env').and_return(path_of_module_foo)
      end
      it 'runs against foo' do
        is_expected.to run.with_params('foo').and_return(path_of_module_foo.path)
      end

      it 'when the modulepath is a list' do
        Puppet[:modulepath] = modulepath + 'tmp/something_else'

        is_expected.to run.with_params('foo').and_return(path_of_module_foo.path)
      end
    end

    context 'when in a non-default default environment' do
      let(:environment) { 'test' }

      before(:each) do
        allow(Puppet::Module).to receive(:find).with('foo', 'test').and_return(path_of_module_foo)
      end
      it 'runs against foo' do
        is_expected.to run.with_params('foo').and_return(path_of_module_foo.path)
      end

      it 'when the modulepath is a list' do
        Puppet[:modulepath] = modulepath + 'tmp/something_else'
        is_expected.to run.with_params('foo').and_return(path_of_module_foo.path)
      end
    end
  end
end
