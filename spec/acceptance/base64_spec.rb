require 'spec_helper_acceptance'

describe 'base64 function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  it 'should encode then decode a string' do
    pp = <<-EOS
    $encodestring = base64('encode', 'thestring')
    $decodestring = base64('decode', $encodestring)
    notify { $decodestring: }
    EOS

    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stdout).to match(/thestring/)
    end
  end
end
