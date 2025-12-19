# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'loadjson' do
  context 'when loading JSON from an URL' do
    let(:pp) do
      <<-MANIFEST
        loadjson('https://api.github.com/repos/puppetlabs/puppet')
      MANIFEST
    end

    it 'would apply manifest' do
      apply_manifest(pp, catch_failures: true)
    end
  end
end
