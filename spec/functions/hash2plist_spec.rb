require 'spec_helper'

describe 'hash2plist' do

  xml_plist = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>test</key>
    <string>string</string>
  </dict>
</plist>
EOF

  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }

  it { is_expected.to run.with_params("string").and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params("string", xml).and_raise_error(Puppet::ParseError) }

  it { is_expected.to run.with_params({'test' => 'string'}).and_return(xml_plist) }
  it { is_expected.to run.with_params({'test' => 'string'}, xml).and_return(xml_plist) }

end
