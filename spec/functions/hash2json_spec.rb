require 'spec_helper'

puts Puppet::Parser::Functions.function(:hash2json)

describe 'the hash2json function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  let(:sample_hash) {{
    'foo_str'      => 'bar',
    'foo_int'  => 1,
    'foo_arr'  => ['a', 'b', 'c'],
    'foo_hash' => {
      'foo_key' => 'foo_val'
    },
  }}

# Chop newline created by OEF
expected_json = <<-EOF.chop
{
\t"foo_arr": ["a","b","c"],
\t"foo_hash": {
\t\t"foo_key": "foo_val"
\t},
\t"foo_int": 1,
\t"foo_str": "bar"
}
EOF

  it "should exist" do
    expect(Puppet::Parser::Functions.function("hash2json")).to eq("function_hash2json")
  end

  it "should raise ParseError if there is not exactly 1 arguments" do
    expect { scope.function_hash2json([]) }.to( raise_error(Puppet::ParseError, /Wrong number of arguments/))
  end

  it "should raise ParseError if arguement 1 is not a Hash" do
    expect { scope.function_hash2json([]) }.to raise_error(Puppet::ParseError, /Wrong number of arguments/)
    expect { scope.function_hash2json(['foo', 'bar']) }.to( raise_error(Puppet::ParseError, /Wrong number of arguments/))
  end

  it "should require the first value to be a Hash" do
    expect { scope.function_hash2json(['foo']) }.to( raise_error(Puppet::ParseError, /argument must be a Hash/))
  end

  it "should convert a hash to a json string" do
    expect(scope.function_hash2json([sample_hash])).to eq(expected_json)
  end
end
