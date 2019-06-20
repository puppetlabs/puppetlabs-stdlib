require 'spec_helper'

describe 'loadjson' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }

  describe 'when calling with valid arguments' do
    before :each do
      allow(File).to receive(:read).with(%r{\/(stdlib|test)\/metadata.json}, :encoding => 'utf-8').and_return('{"name": "puppetlabs-stdlib"}')
      allow(File).to receive(:read).with(%r{\/(stdlib|test)\/metadata.json}).and_return('{"name": "puppetlabs-stdlib"}')
      # Additional modules used by litmus which are identified while running these dues to being in fixtures
      allow(File).to receive(:read).with(%r{\/(provision|puppet_agent|facts)\/metadata.json}, :encoding => 'utf-8')
    end

    context 'when a non-existing file is specified' do
      let(:filename) do
        if Puppet::Util::Platform.windows?
          'C:/tmp/doesnotexist'
        else
          '/tmp/doesnotexist'
        end
      end

      before(:each) do
        allow(File).to receive(:exists?).with(filename).and_return(false).once
        allow(PSON).to receive(:load).never
      end
      it { is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value') }
      it { is_expected.to run.with_params(filename, 'đẽƒằưļŧ' => '٧ẵłựέ').and_return('đẽƒằưļŧ' => '٧ẵłựέ') }
      it { is_expected.to run.with_params(filename, 'デフォルト' => '値').and_return('デフォルト' => '値') }
    end

    context 'when an existing file is specified' do
      let(:filename) do
        if Puppet::Util::Platform.windows?
          'C:/tmp/doesexist'
        else
          '/tmp/doesexist'
        end
      end
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", {"ķęŷ":"νậŀųề" }, {"キー":"値" }' }

      before(:each) do
        allow(File).to receive(:exists?).with(filename).and_return(true).once
        allow(File).to receive(:read).with(filename).and_return(json).once
        allow(File).to receive(:read).with(filename).and_return(json).once
        allow(PSON).to receive(:load).with(json).and_return(data).once
      end
      it { is_expected.to run.with_params(filename).and_return(data) }
    end

    context 'when the file could not be parsed' do
      let(:filename) do
        if Puppet::Util::Platform.windows?
          'C:/tmp/doesexist'
        else
          '/tmp/doesexist'
        end
      end
      let(:json) { '{"key":"value"}' }

      before(:each) do
        allow(File).to receive(:exists?).with(filename).and_return(true).once
        allow(File).to receive(:read).with(filename).and_return(json).once
        allow(PSON).to receive(:load).with(json).once.and_raise StandardError, 'Something terrible have happened!'
      end
      it { is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value') }
    end

    context 'when an existing URL is specified' do
      let(:filename) do
        'https://example.local/myhash.json'
      end
      let(:basic_auth) { { :http_basic_authentication => ['', ''] } }
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", {"ķęŷ":"νậŀųề" }, {"キー":"値" }' }

      it {
        expect(OpenURI).to receive(:open_uri).with(filename, basic_auth).and_return(json)
        expect(PSON).to receive(:load).with(json).and_return(data).once
        is_expected.to run.with_params(filename).and_return(data)
      }
    end

    context 'when an existing URL (with username and password) is specified' do
      let(:filename) do
        'https://user1:pass1@example.local/myhash.json'
      end
      let(:url_no_auth) { 'https://example.local/myhash.json' }
      let(:basic_auth) { { :http_basic_authentication => ['user1', 'pass1'] } }
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", {"ķęŷ":"νậŀųề" }, {"キー":"値" }' }

      it {
        expect(OpenURI).to receive(:open_uri).with(url_no_auth, basic_auth).and_return(json)
        expect(PSON).to receive(:load).with(json).and_return(data).once
        is_expected.to run.with_params(filename).and_return(data)
      }
    end

    context 'when an existing URL (with username) is specified' do
      let(:filename) do
        'https://user1@example.local/myhash.json'
      end
      let(:url_no_auth) { 'https://example.local/myhash.json' }
      let(:basic_auth) { { :http_basic_authentication => ['user1', ''] } }
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", {"ķęŷ":"νậŀųề" }, {"キー":"値" }' }

      it {
        expect(OpenURI).to receive(:open_uri).with(url_no_auth, basic_auth).and_return(json)
        expect(PSON).to receive(:load).with(json).and_return(data).once
        is_expected.to run.with_params(filename).and_return(data)
      }
    end

    context 'when the URL output could not be parsed, with default specified' do
      let(:filename) do
        'https://example.local/myhash.json'
      end
      let(:basic_auth) { { :http_basic_authentication => ['', ''] } }
      let(:json) { ',;{"key":"value"}' }

      it {
        expect(OpenURI).to receive(:open_uri).with(filename, basic_auth).and_return(json)
        expect(PSON).to receive(:load).with(json).once.and_raise StandardError, 'Something terrible have happened!'
        is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value')
      }
    end

    context 'when the URL does not exist, with default specified' do
      let(:filename) do
        'https://example.local/myhash.json'
      end
      let(:basic_auth) { { :http_basic_authentication => ['', ''] } }

      it {
        expect(OpenURI).to receive(:open_uri).with(filename, basic_auth).and_raise OpenURI::HTTPError, '404 File not Found'
        is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value')
      }
    end
  end
end
