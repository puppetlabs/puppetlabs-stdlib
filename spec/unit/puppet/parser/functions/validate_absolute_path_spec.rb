require 'spec_helper'

describe Puppet::Parser::Functions.function(:validate_absolute_path) do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  let(:scope) do
    scope = Puppet::Parser::Scope.new
  end

  # The subject of these examplres is the method itself.
  subject do
    scope.method :function_validate_absolute_path
  end

  context 'Using Puppet::Parser::Scope.new' do

    describe 'Garbage inputs' do
      paths = [
        nil,
        [ nil ],
        { 'foo' => 'bar' },
        { },
        '',
      ]

      paths.each do |path|
        it "validate_absolute_path(#{path.inspect}) should fail" do
          expect { subject.call [path] }.to raise_error Puppet::ParseError
        end
      end
    end
    describe 'relative paths' do
      paths = %w{
        relative1
        .
        ..
        ./foo
        ../foo
        etc/puppetlabs/puppet
        opt/puppet/bin
      }

      paths.each do |path|
        it "validate_absolute_path(#{path.inspect}) should fail" do
          expect { subject.call [path] }.to raise_error Puppet::ParseError
        end
      end
    end
    describe 'absolute paths' do
      paths = %w{
        C:/
        C:\\
        C:\\WINDOWS\\System32
        C:/windows/system32
        X:/foo/bar
        X:\\foo\\bar
        /var/tmp
        /var/lib/puppet
        /var/opt/../lib/puppet
      }

      paths = paths + [
        'C:\\Program Files (x86)\\Puppet Labs\\Puppet Enterprise',
        'C:/Program Files (x86)/Puppet Labs/Puppet Enterprise',
      ]

      paths.each do |path|
        it "validate_absolute_path(#{path.inspect}) should not fail" do
          expect { subject.call [path] }.not_to raise_error
        end
      end
    end
  end
end
