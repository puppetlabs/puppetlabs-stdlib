require 'spec_helper'

describe 'load_module_metadata' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params("one", "two", "three").and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }

  describe "when calling with valid arguments" do
    before :each do
      if RSpec.configuration.puppet_future
        allow(File).to receive(:read).with(/\/stdlib\/metadata.json/, {:encoding=>"utf-8"}).and_return('{"name": "puppetlabs-stdlib"}')
      else
        allow(File).to receive(:read).with(/\/stdlib\/metadata.json/).and_return('{"name": "puppetlabs-stdlib"}')
      end
    end
    it "should json parse the file" do
      allow(scope).to receive(:function_get_module_path).with(['science']).and_return('/path/to/module/')
      allow(File).to receive(:exists?).with('/path/to/module/metadata.json').and_return(true)
      allow(File).to receive(:read).with('/path/to/module/metadata.json').and_return('{"name": "spencer-science"}')

      result = subject.call(['science'])
      expect(result['name']).to eq('spencer-science')
    end

    it "should fail by default if there is no metadata.json" do
      allow(scope).to   receive(:function_get_module_path).with(['science']).and_return('/path/to/module/')
      allow(File).to receive(:exists?).with('/path/to/module/metadata.json').and_return(false)
      expect {subject.call(['science'])}.to raise_error(Puppet::ParseError)
    end

    it "should return nil if user allows empty metadata.json" do
      allow(scope).to receive(:function_get_module_path).with(['science']).and_return('/path/to/module/')
      allow(File).to receive(:exists?).with('/path/to/module/metadata.json').and_return(false)
      result = subject.call(['science', true])
      expect(result).to eq({})
    end
  end
end
