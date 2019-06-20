require 'spec_helper_acceptance'

describe 'anchor type' do
  let(:pp) do
    <<-MANIFEST
      class anchored {
        anchor { 'anchored::begin': }
        ~> anchor { 'anchored::end': }
      }

      class anchorrefresh {
        notify { 'first': }
        ~> class { 'anchored': }
        ~> anchor { 'final': }
      }

      include anchorrefresh
    MANIFEST
  end

  it 'applies manifest, anchors resources in correct order' do
    apply_manifest(pp) do |r|
      expect(r.stdout).to match(%r{Anchor\[final\]: Triggered 'refresh'})
    end
  end
end
