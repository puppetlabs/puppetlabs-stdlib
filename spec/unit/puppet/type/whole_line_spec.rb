require 'puppet'
require 'tempfile'
describe Puppet::Type.type(:whole_line) do
  before :each do
    @whole_line = Puppet::Type.type(:whole_line).new(:name => 'foo', :line => 'line', :path => '/tmp/path')
  end
  it 'should accept a line and path' do
    @whole_line[:line] = 'my_line'
    @whole_line[:line].should == 'my_line'
  end
  it 'should accept posix filenames' do
    @whole_line[:path] = '/tmp/path'
    @whole_line[:path].should == '/tmp/path'
  end
  it 'should not accept unqualified path' do
    expect { @whole_line[:path] = 'file' }.should raise_error(Puppet::Error, /File paths must be fully qualified/)
  end
  it 'should require that a line is specified' do
    expect { Puppet::Type.type(:whole_line).new(:name => 'foo', :path => '/tmp/file') }.should raise_error(Puppet::Error, /Both line and path are required attributes/)
  end
  it 'should require that a file is specified' do
    expect { Puppet::Type.type(:whole_line).new(:name => 'foo', :line => 'path') }.should raise_error(Puppet::Error, /Both line and path are required attributes/)
  end
end
