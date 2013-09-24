#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe Puppet::Parser::Functions.function(:rmerge) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  describe 'when calling rmerge from puppet' do
    it "should not compile when no arguments are passed" do
      pending("Fails on 2.6.x, see bug #15912") if Puppet.version =~ /^2\.6\./
      Puppet[:code] = '$x = rmerge()'
      expect {
        scope.compiler.compile
      }.to raise_error(Puppet::ParseError, /wrong number of arguments/)
    end

    it "should not compile when 1 argument is passed" do
      pending("Fails on 2.6.x, see bug #15912") if Puppet.version =~ /^2\.6\./
      Puppet[:code] = "$my_hash={'one' => 1}\n$x = rmerge($my_hash)"
      expect {
        scope.compiler.compile
      }.to raise_error(Puppet::ParseError, /wrong number of arguments/)
    end
  end

  describe 'when calling rmerge on the scope instance' do
    it 'should require all parameters are hashes' do
      expect { new_hash = scope.function_rmerge([{}, '2'])}.to raise_error(Puppet::ParseError, /unexpected argument type String/)
      expect { new_hash = scope.function_rmerge([{}, 2])}.to raise_error(Puppet::ParseError, /unexpected argument type Fixnum/)
    end

    it 'should accept empty strings as puppet undef' do
      expect { new_hash = scope.function_rmerge([{}, ''])}.not_to raise_error(Puppet::ParseError, /unexpected argument type String/)
    end

    it 'should be able to rmerge two hashes' do
      new_hash = scope.function_rmerge([{'one' => '1', 'two' => '1'}, {'two' => '2', 'three' => '2'}])
      new_hash['one'].should   == '1'
      new_hash['two'].should   == '2'
      new_hash['three'].should == '2'
    end

    it 'should rmerge multiple hashes' do
      hash = scope.function_rmerge([{'one' => 1}, {'one' => '2'}, {'one' => '3'}])
      hash['one'].should == '3'
    end

    it 'should accept empty hashes' do
      scope.function_rmerge([{},{},{}]).should == {}
    end

    it 'should rmerge subhashes' do
      hash = scope.function_rmerge([{'one' => 1}, {'two' => 2, 'three' => { 'four' => 4 } }])
      hash['one'].should == 1
      hash['two'].should == 2
      hash['three'].should == { 'four' => 4 }
    end

    it 'should append to subhashes' do
      hash = scope.function_rmerge([{'one' => { 'two' => 2 } }, { 'one' => { 'three' => 3 } }])
      hash['one'].should == { 'two' => 2, 'three' => 3 }
    end

    it 'should append to subhashes 2' do
      hash = scope.function_rmerge([{'one' => 1, 'two' => 2, 'three' => { 'four' => 4 } }, {'two' => 'dos', 'three' => { 'five' => 5 } }])
      hash['one'].should == 1
      hash['two'].should == 'dos'
      hash['three'].should == { 'four' => 4, 'five' => 5 }
    end

    it 'should append to subhashes 3' do
      hash = scope.function_rmerge([{ 'key1' => { 'a' => 1, 'b' => 2 }, 'key2' => { 'c' => 3 } }, { 'key1' => { 'b' => 99 } }])
      hash['key1'].should == { 'a' => 1, 'b' => 99 }
      hash['key2'].should == { 'c' => 3 }
    end
  end
end
