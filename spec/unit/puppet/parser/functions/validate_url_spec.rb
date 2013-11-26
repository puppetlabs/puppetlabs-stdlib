#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe Puppet::Parser::Functions.function(:validate_url) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  describe 'when calling validate_url from puppet' do

    %w{ http://puppetlabs.com http://forge.puppetlabs.com ftp://puppetlabs.com:21 }.each do |the_string|

      it "should compile when #{the_string} is a valid url" do
        Puppet[:code] = "validate_url('#{the_string}')"
        scope.compiler.compile
      end
    end

    %w{ http://puppetlabs.com http://forge.puppetlabs.com ftp://puppetlabs.com:21 }.each do |the_string|
      it "should compile when #{the_string} is a valid url, and the scheme of the url is within the accepted set" do
        Puppet[:code] = "validate_url('#{the_string}', ['http','ftp'])"
        scope.compiler.compile
      end
    end

    %w{ puppetlabs mailto:test@puppetlabs.com http:///example 1111::0000 }.each do |the_string|
      it "should not compile when #{the_string} is a not a valid url with a host and scheme" do
        Puppet[:code] = "validate_url('#{the_string}')"
        expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid URL/)
      end
    end

    %w{ http://puppetlabs.com http://forge.puppetlabs.com ftp://puppetlabs.com:21 }.each do |the_string|
      it "should not compile when #{the_string} is a valid url but not with an accepted scheme" do
        Puppet[:code] = "validate_url('#{the_string}', ['gopher','rsync'])"
        expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not an accepted type of URL/)
      end
    end

    %w{ http://puppetlabs.com http://forge.puppetlabs.com ftp://puppetlabs.com:21 }.each do |the_string|
      it "should not compile when #{the_string} is a valid url but an accepted scheme is not a string" do
        Puppet[:code] = "validate_url('#{the_string}', ['gopher', []])"
        expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /the second argument must be a string or array of strings/)
      end
    end

    %w{ true false }.each do |the_string|
      it "should not compile when #{the_string} is a string" do
        Puppet[:code] = "validate_url('#{the_string}')"
        expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid URL/)
      end

      it "should not compile when #{the_string} is a bare word" do
        Puppet[:code] = "validate_url(#{the_string})"
        expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid URL/)
      end
    end

    it "should not compile when an array is passed" do
      Puppet[:code] = <<-'ENDofPUPPETcode'
        $foo = 'http://puppetlabs.com'
        $bar = 'http://forge.puppetlabs.com'
        validate_url( [$foo, $bar] )
      ENDofPUPPETcode
      expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid URL/)
    end

    it "should not compile when a number is passed" do
      Puppet[:code] = <<-'ENDofPUPPETcode'
        $foo = 'http://puppetlabs.com'
        $bar = 'http://forge.puppetlabs.com'
        validate_url( 3 )
      ENDofPUPPETcode
      expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid URL/)
    end

    it "should not compile when a hash is passed" do
      Puppet[:code] = <<-'ENDofPUPPETcode'
        $foo = 'http://puppetlabs.com'
        $bar = 'http://forge.puppetlabs.com'
        validate_url( { foo => "bar" } )
      ENDofPUPPETcode
      expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid URL/)
    end

    it "should not compile when an explicitly undef variable is passed (NOTE THIS MAY NOT BE DESIRABLE)" do
      Puppet[:code] = <<-'ENDofPUPPETcode'
        $foo = undef
        validate_url($foo)
      ENDofPUPPETcode
      expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid URL/)
    end

    it "should not compile when an undefined variable is passed (NOTE THIS MAY NOT BE DESIRABLE)" do
      Puppet[:code] = <<-'ENDofPUPPETcode'
        validate_url($foobarbazishouldnotexist)
      ENDofPUPPETcode
      expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid URL/)
    end
  end
end
