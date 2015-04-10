#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the pw_hash function" do

  before :all do
    @enhanced_salts_supported = RUBY_PLATFORM == 'java'
  end

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("pw_hash")).to eq("function_pw_hash")
  end

  it "should raise an ArgumentError if there are less than 3 arguments" do
    expect { scope.function_pw_hash([]) }.to( raise_error(ArgumentError, /[Ww]rong number of arguments/) )
    expect { scope.function_pw_hash(['password']) }.to( raise_error(ArgumentError, /[Ww]rong number of arguments/) )
    expect { scope.function_pw_hash(['password', 'sha-512']) }.to( raise_error(ArgumentError, /[Ww]rong number of arguments/) )
  end

  it "should raise an ArgumentError if there are more than 3 arguments" do
    expect { scope.function_pw_hash(['password', 'sha-512', 'salt', 5]) }.to( raise_error(ArgumentError, /[Ww]rong number of arguments/) )
  end

  it "should raise an ArgumentError if the first argument is not a string" do
    expect { scope.function_pw_hash([['password'], 'sha-512', 'salt']) }.to( raise_error(ArgumentError, /first argument must be a string/) )
    # in Puppet 3, numbers are passed as strings, so we can't test that
  end

  it "should return nil if the first argument is empty" do
    expect(scope.function_pw_hash(['', 'sha-512', 'salt'])).to eq(nil)
  end

  it "should return nil if the first argument is undef" do
    expect(scope.function_pw_hash([nil, 'sha-512', 'salt'])).to eq(nil)
  end

  it "should raise an ArgumentError if the second argument is an invalid hash type" do
    expect { scope.function_pw_hash(['', 'invalid', 'salt']) }.to( raise_error(ArgumentError, /not a valid hash type/) )
  end

  it "should raise an ArgumentError if the second argument is not a string" do
    expect { scope.function_pw_hash(['', [], 'salt']) }.to( raise_error(ArgumentError, /second argument must be a string/) )
  end

  it "should raise an ArgumentError if the third argument is not a string" do
    expect { scope.function_pw_hash(['password', 'sha-512', ['salt']]) }.to( raise_error(ArgumentError, /third argument must be a string/) )
    # in Puppet 3, numbers are passed as strings, so we can't test that
  end

  it "should raise an ArgumentError if the third argument is empty" do
    expect { scope.function_pw_hash(['password', 'sha-512', '']) }.to( raise_error(ArgumentError, /third argument must not be empty/) )
  end

  it "should raise an ArgumentError if the third argument has invalid characters" do
    expect { scope.function_pw_hash(['password', 'sha-512', '%']) }.to( raise_error(ArgumentError, /characters in salt must be in the set/) )
  end

  it "should fail on platforms with weak implementations of String#crypt" do
    String.any_instance.expects(:crypt).with('$1$1').returns('$1SoNol0Ye6Xk')
    expect { scope.function_pw_hash(['password', 'sha-512', 'salt']) }.to( raise_error(Puppet::ParseError, /system does not support enhanced salts/) )
  end

  if @enhanced_salts_supported
    describe "on systems with enhanced salts support" do
      it "should return a hashed password" do
        result = scope.function_pw_hash(['password', 'sha-512', 'salt'])
        expect(result).to eql('$6$salt$IxDD3jeSOb5eB1CX5LBsqZFVkJdido3OUILO5Ifz5iwMuTS4XMS130MTSuDDl3aCI6WouIL9AjRbLCelDCy.g.')
      end

      it "should use the specified salt" do
        result = scope.function_pw_hash(['password', 'sha-512', 'salt'])
        expect(result).to match('salt')
      end

      it "should use the specified hash type" do
        resultmd5 = scope.function_pw_hash(['password', 'md5', 'salt'])
        resultsha256 = scope.function_pw_hash(['password', 'sha-256', 'salt'])
        resultsha512 = scope.function_pw_hash(['password', 'sha-512', 'salt'])

        expect(resultmd5).to eql('$1$salt$qJH7.N4xYta3aEG/dfqo/0')
        expect(resultsha256).to eql('$5$salt$Gcm6FsVtF/Qa77ZKD.iwsJlCVPY0XSMgLJL0Hnww/c1')
        expect(resultsha512).to eql('$6$salt$IxDD3jeSOb5eB1CX5LBsqZFVkJdido3OUILO5Ifz5iwMuTS4XMS130MTSuDDl3aCI6WouIL9AjRbLCelDCy.g.')
      end

      it "should generate a valid hash" do
        password_hash = scope.function_pw_hash(['password', 'sha-512', 'salt'])

        hash_parts = password_hash.match(%r{\A\$(.*)\$([a-zA-Z0-9./]+)\$([a-zA-Z0-9./]+)\z})

        expect(hash_parts).not_to eql(nil)
      end
    end
  end
end
