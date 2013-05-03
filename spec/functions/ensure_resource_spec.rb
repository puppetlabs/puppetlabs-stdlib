#! /usr/bin/env ruby -S rspec
require 'spec_helper'

require 'rspec-puppet'
describe 'ensure_resource' do
  describe 'when a type or title is not specified' do
    it do
      should run.with_params().and_raise_error(ArgumentError)
      should run.with_params(['type']).and_raise_error(ArgumentError)
    end
  end
  describe 'when compared against a resource with no attributes' do
    let :pre_condition do
      'user { "dan": }'
    end
    it do
      should run.with_params('user', 'dan', {})
      compiler.catalog.resource('User[dan]').to_s.should == 'User[dan]'
    end
  end

  describe 'when compared against a resource with attributes' do
    let :pre_condition do
      'user { "dan": ensure => present, shell => "/bin/csh", managehome => false}'
    end
    it do
      # these first three should not fail
      should run.with_params('User', 'dan', {})
      should run.with_params('User', 'dan', '')
      should run.with_params('User', 'dan', {'ensure' => 'present'})
      should run.with_params('User', 'dan',
                             {'ensure' => 'present', 'managehome' => false}
                            )
      #  test that this fails
      should run.with_params('User', 'dan',
                             {'ensure' => 'absent', 'managehome' => false}
                            ).and_raise_error(Puppet::Error)
    end
  end

  describe 'when an array of new resources are passed in' do
    it do
      should run.with_params('User', ['dan', 'alex'], {})
      compiler.catalog.resource('User[dan]').to_s.should == 'User[dan]'
      compiler.catalog.resource('User[alex]').to_s.should == 'User[alex]'
    end
  end

  describe 'when an array of existing resources is compared against existing resources' do
    let :pre_condition do
      'user { "dan": ensure => present; "alex": ensure => present }'
    end
    it do
      should run.with_params('User', ['dan', 'alex'], {})
      compiler.catalog.resource('User[dan]').to_s.should == 'User[dan]'
      compiler.catalog.resource('User[alex]').to_s.should == 'User[alex]'
    end
  end

  describe 'when compared against existing resources with attributes' do
    let :pre_condition do
      'user { "dan": ensure => present; "alex": ensure => present }'
    end
    it do
      # These should not fail
      should run.with_params('User', ['dan', 'alex'], {})
      should run.with_params('User', ['dan', 'alex'], '')
      should run.with_params('User', ['dan', 'alex'], {'ensure' => 'present'})
      # This should fail
      should run.with_params('User', ['dan', 'alex'],
                             {'ensure' => 'absent'}
                            ).and_raise_error(Puppet::Error)
    end
  end
end
