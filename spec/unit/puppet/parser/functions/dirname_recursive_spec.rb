#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dirname_recursive function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("dirname_recursive").should == "function_dirname_recursive"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_dirname_recursive([]) }.should( raise_error(Puppet::ParseError))
  end

  context 'when validating input parameters' do
    it 'should accept a valid path argument' do
      result = scope.function_dirname_recursive(['/path/to/a/file.ext'])
    end

    it 'should fail with a wrong path argument' do
      expect {
        scope.function_dirname_recursive([['/path/to/a/file.ext']])
      }.to raise_error(Puppet::ParseError, /'path' should be of type string, not Array\./)
    end

    it 'should accept a valid excludes argument' do
      result = scope.function_dirname_recursive(['/path/to/a/file.ext', ['/etc', '/root']])
    end

    it 'should fail with a wrong path argument' do
      expect {
        scope.function_dirname_recursive(['/path/to/a/file.ext', '/etc'])
      }.to raise_error(Puppet::ParseError, /'excludes' should be of type array, not String\./)
    end

    it 'should accept a valid upper_limit argument' do
      result = scope.function_dirname_recursive(['/path/to/a/file.ext', [], 1])
    end

    it 'should fail with a wrong upper_limit argument' do
      expect {
        scope.function_dirname_recursive(['/path/to/a/file.ext', [], 'foo'])
      }.to raise_error(Puppet::ParseError, /'upper_limit' should be of type integer, not String\./)
    end

    it 'should accept a valid lower_limit argument' do
      result = scope.function_dirname_recursive(['/path/to/a/file.ext', [], 1, 2])
    end

    it 'should fail with a wrong lower_limit argument' do
      expect {
        scope.function_dirname_recursive(['/path/to/a/file.ext', [], 1, 'foo'])
      }.to raise_error(Puppet::ParseError, /'lower_limit' should be of type integer, not String\./)
    end
  end

  context 'when using default filters' do
    it "should return dirnames for an absolute path" do
      result = scope.function_dirname_recursive(['/path/to/a/file.ext'])
      result.should(eq(['/path/to/a', '/path/to', '/path']))
    end

    it "should return dirnames for a relative path" do
      result = scope.function_dirname_recursive(['path/to/a/file.ext'])
      result.should(eq(['path/to/a', 'path/to', 'path']))
    end
  end

  context 'when using excludes' do
    it "should return dirnames for an absolute path" do
      result = scope.function_dirname_recursive(['/path/to/a/file.ext', ['/path/to', '/path', '/etc']])
      result.should(eq(['/path/to/a']))
    end

    it "should return dirnames for a relative path" do
      result = scope.function_dirname_recursive(['path/to/a/file.ext', ['path/to', 'path']])
      result.should(eq(['path/to/a']))
    end
  end

  context 'when using upper_limit' do
    it "should return dirnames for an absolute path" do
      result = scope.function_dirname_recursive(['/path/to/a/file.ext', [], 1])
      result.should(eq(['/path/to/a', '/path/to', '/path']))
    end

    it "should return dirnames for a relative path" do
      result = scope.function_dirname_recursive(['path/to/a/file.ext', [], 1])
      result.should(eq(['path/to/a', 'path/to', 'path']))
    end
  end

  context 'when using lower_limit' do
    it "should return dirnames for an absolute path" do
      result = scope.function_dirname_recursive(['/path/to/a/file.ext', [], 0, 1])
      result.should(eq(['/path/to/a']))
    end

    it "should return dirnames for a relative path" do
      result = scope.function_dirname_recursive(['path/to/a/file.ext', [], 0, 1])
      result.should(eq(['path/to/a']))
    end
  end
end
