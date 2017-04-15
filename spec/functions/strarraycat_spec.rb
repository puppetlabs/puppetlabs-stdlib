#! /usr/bin/env ruby -S rspec
require 'spec_helper'
require 'rspec-puppet'

$array = [ 'puppet', 'stdlib' ]
$larray = [ 'moe', 'curly', 'vince' ]
$string = '/var/lib/git'

describe 'strarraycat' do
  describe 'when input is bad' do
    it do
      should run.with_params(['foo', 'bar']).and_raise_error(ArgumentError)
      should run.with_params('foo', 'bar').and_raise_error(ArgumentError)
      should run.with_params('foo').and_raise_error(ArgumentError)
      should run.with_params('foo', $array, 'foo').and_raise_error(ArgumentError)
      should run.with_params().and_raise_error(ArgumentError)
    end
  end
  describe 'when input is good' do
    it do
      should.run.with_params($string, $array).and_return
      (['/var/lib/gitpuppet', '/var/lib/gitstdlib'])
      should.run.with_params($string, $array, '/').and_return
      (['/var/lib/git/puppet', '/var/lib/git/stdlib'])
      should.run.with_params($array, $array, '/').and_return
      (['puppet/stdlib', ['stdlib/puppet'])
      should.run.with_params($array, $larray, '/').and_return
      (['puppet/moe', 'puppet/curly', 'puppet/vince',
        'stdlib/moe', 'stdlib/curly', 'stdlib/vince'])
    end
  end
end

# vim: set ts=2 sw=2 et :
