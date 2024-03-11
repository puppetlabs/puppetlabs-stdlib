# frozen_string_literal: true

require 'spec_helper'
require 'open-uri'

describe 'loadjson' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, "'loadjson' expects between 1 and 2 arguments, got none") }

  describe 'when calling with valid arguments' do
    context 'when a non-existing file is specified' do
      let(:filename) do
        file = Tempfile.create
        file.close
        File.unlink(file.path)
        file.path
      end

      before(:each) do
        if Puppet::PUPPETVERSION[0].to_i < 8
          allow(PSON).to receive(:load).never # rubocop:disable RSpec/ReceiveNever  Switching to not_to receive breaks testing in this case
        else
          allow(JSON).to receive(:parse).never # rubocop:disable RSpec/ReceiveNever
        end
      end

      it { is_expected.to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'}) }
      it { is_expected.to run.with_params(filename, {'đẽƒằưļŧ' => '٧ẵłựέ'}).and_return({'đẽƒằưļŧ' => '٧ẵłựέ'}) }
      it { is_expected.to run.with_params(filename, {'デフォルト' => '値'}).and_return({'デフォルト' => '値'}) }
    end

    context 'when an existing file is specified' do
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", {"ķęŷ":"νậŀųề" }, {"キー":"値" }' }

      it do
        Tempfile.new do |file|
          file.write(json)
          file.flush

          is_expected.to run.with_params(file.path).and_return(data)
        end
      end
    end

    context 'when the file could not be parsed' do
      let(:json) { '{"key":"value"}' }

      it do
        Tempfile.new do |file|
          file.write(json)
          file.flush

          is_expected.to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'})
        end
      end
    end

    context 'when an existing URL is specified' do
      let(:filename) do
        'https://example.com/myhash.json'
      end
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", "ķęŷ":"νậŀųề", "キー":"値" }' }

      it {
        expect(URI).to receive(:open).with(filename).and_yield(json)
        expect(subject).to run.with_params(filename).and_return(data)
      }
    end

    context 'when the URL output could not be parsed, with default specified' do
      let(:filename) do
        'https://example.com/myhash.json'
      end
      let(:json) { ',;{"key":"value"}' }

      it {
        expect(URI).to receive(:open).with(filename).and_yield(json)
        if Puppet::PUPPETVERSION[0].to_i < 8
          expect(PSON).to receive(:load).with(json).once.and_raise StandardError, 'Something terrible have happened!'
        else
          expect(JSON).to receive(:load).with(json).once.and_raise StandardError, 'Something terrible have happened!'
        end
        expect(subject).to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'})
      }
    end

    context 'when the URL does not exist, with default specified' do
      let(:filename) do
        'https://example.com/myhash.json'
      end

      it {
        expect(URI).to receive(:open).with(filename).and_raise OpenURI::HTTPError, '404 File not Found'
        expect(subject).to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'})
      }
    end
  end
end
