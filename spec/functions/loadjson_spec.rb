# frozen_string_literal: true

require 'spec_helper'

describe 'loadjson' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }

  describe 'when calling with valid arguments' do
    before :each do
      # In Puppet 7, there are two prior calls to File.read prior to the responses we want to mock
      allow(File).to receive(:read).with(anything, anything).and_call_original
      allow(File).to receive(:read).with(%r{/(stdlib|test)/metadata.json}, encoding: 'utf-8').and_return('{"name": "puppetlabs-stdlib"}')
      allow(File).to receive(:read).with(%r{/(stdlib|test)/metadata.json}).and_return('{"name": "puppetlabs-stdlib"}')
      # Additional modules used by litmus which are identified while running these dues to being in fixtures
      allow(File).to receive(:read).with(%r{/(provision|puppet_agent|facts)/metadata.json}, encoding: 'utf-8')
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
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(filename).and_return(false).once
        if Puppet::PUPPETVERSION[0].to_i < 8
          allow(PSON).to receive(:load).never # rubocop:disable RSpec/ReceiveNever  Switching to not_to receive breaks testing in this case
        else
          allow(JSON).to receive(:parse).never # rubocop:disable RSpec/ReceiveNever
        end
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
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(filename).and_return(true).once
        allow(File).to receive(:read).with(filename).and_return(json).once
        if Puppet::PUPPETVERSION[0].to_i < 8
          allow(PSON).to receive(:load).with(json).and_return(data).once
        else
          allow(JSON).to receive(:parse).with(json).and_return(data).once
        end
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
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(filename).and_return(true).once
        allow(File).to receive(:read).with(filename).and_return(json).once
        if Puppet::PUPPETVERSION[0].to_i < 8
          allow(PSON).to receive(:load).with(json).once.and_raise StandardError, 'Something terrible have happened!'
        else
          allow(JSON).to receive(:parse).with(json).once.and_raise StandardError, 'Something terrible have happened!'
        end
      end

      it { is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value') }
    end

    context 'when an existing URL is specified' do
      let(:filename) do
        'https://example.local/myhash.json'
      end
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", {"ķęŷ":"νậŀųề" }, {"キー":"値" }' }

      it {
        expect(OpenURI).to receive(:open_uri).with(filename, {}).and_return(StringIO.new(json))
        if Puppet::PUPPETVERSION[0].to_i < 8
          expect(PSON).to receive(:load).with(json).and_return(data).once
        else
          expect(JSON).to receive(:parse).with(json).and_return(data).once
        end
        expect(subject).to run.with_params(filename).and_return(data)
      }
    end

    context 'when an existing URL (with username and password) is specified' do
      let(:filename) do
        'https://user1:pass1@example.local/myhash.json'
      end
      let(:url_no_auth) { 'https://example.local/myhash.json' }
      let(:basic_auth) { { http_basic_authentication: ['user1', 'pass1'] } }
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", {"ķęŷ":"νậŀųề" }, {"キー":"値" }' }

      it {
        expect(OpenURI).to receive(:open_uri).with(url_no_auth, basic_auth).and_return(StringIO.new(json))
        if Puppet::PUPPETVERSION[0].to_i < 8
          expect(PSON).to receive(:load).with(json).and_return(data).once
        else
          expect(JSON).to receive(:parse).with(json).and_return(data).once
        end
        expect(subject).to run.with_params(filename).and_return(data)
      }
    end

    context 'when an existing URL (with username) is specified' do
      let(:filename) do
        'https://user1@example.local/myhash.json'
      end
      let(:url_no_auth) { 'https://example.local/myhash.json' }
      let(:basic_auth) { { http_basic_authentication: ['user1', ''] } }
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", {"ķęŷ":"νậŀųề" }, {"キー":"値" }' }

      it {
        expect(OpenURI).to receive(:open_uri).with(url_no_auth, basic_auth).and_return(StringIO.new(json))
        if Puppet::PUPPETVERSION[0].to_i < 8
          expect(PSON).to receive(:load).with(json).and_return(data).once
        else
          expect(JSON).to receive(:parse).with(json).and_return(data).once
        end
        expect(subject).to run.with_params(filename).and_return(data)
      }
    end

    context 'when the URL output could not be parsed, with default specified' do
      let(:filename) do
        'https://example.local/myhash.json'
      end
      let(:json) { ',;{"key":"value"}' }

      it {
        expect(OpenURI).to receive(:open_uri).with(filename, {}).and_return(StringIO.new(json))
        if Puppet::PUPPETVERSION[0].to_i < 8
          expect(PSON).to receive(:load).with(json).once.and_raise StandardError, 'Something terrible have happened!'
        else
          expect(JSON).to receive(:parse).with(json).once.and_raise StandardError, 'Something terrible have happened!'
        end
        expect(subject).to run.with_params(filename, 'default' => 'value').and_return('default' => 'value')
      }
    end

    context 'when the URL does not exist, with default specified' do
      let(:filename) do
        'https://example.local/myhash.json'
      end

      it {
        expect(OpenURI).to receive(:open_uri).with(filename, {}).and_raise OpenURI::HTTPError, '404 File not Found'
        expect(subject).to run.with_params(filename, 'default' => 'value').and_return('default' => 'value')
      }
    end
  end
end
