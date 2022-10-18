# frozen_string_literal: true

require 'spec_helper'

describe 'pw_hash' do
  it { is_expected.not_to eq(nil) }

  context 'when there are less than 3 arguments' do
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('password').and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('password', 'sha-256').and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
  end

  context 'when there are more than 3 arguments' do
    it { is_expected.to run.with_params('password', 'sha-256', 'salt', 'extra').and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('password', 'sha-256', 'salt', 'extra', 'extra').and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
  end

  context 'when the first argument is not a string' do
    it { is_expected.to run.with_params([], 'sha-256', 'salt').and_raise_error(ArgumentError, %r{first argument must be a string}) }
    it { is_expected.to run.with_params({}, 'sha-256', 'salt').and_raise_error(ArgumentError, %r{first argument must be a string}) }
    it { is_expected.to run.with_params(1, 'sha-256', 'salt').and_raise_error(ArgumentError, %r{first argument must be a string}) }
    it { is_expected.to run.with_params(true, 'sha-256', 'salt').and_raise_error(ArgumentError, %r{first argument must be a string}) }
  end

  context 'when the first argument is undefined' do
    it { is_expected.to run.with_params('', 'sha-256', 'salt').and_return(nil) }
    it { is_expected.to run.with_params(nil, 'sha-256', 'salt').and_return(nil) }
  end

  context 'when the second argument is not a string' do
    it { is_expected.to run.with_params('password', [], 'salt').and_raise_error(ArgumentError, %r{second argument must be a string}) }
    it { is_expected.to run.with_params('password', {}, 'salt').and_raise_error(ArgumentError, %r{second argument must be a string}) }
    it { is_expected.to run.with_params('password', 1, 'salt').and_raise_error(ArgumentError, %r{second argument must be a string}) }
    it { is_expected.to run.with_params('password', true, 'salt').and_raise_error(ArgumentError, %r{second argument must be a string}) }
  end

  context 'when the second argument is not one of the supported hashing algorithms' do
    it { is_expected.to run.with_params('password', 'no such algo', 'salt').and_raise_error(ArgumentError, %r{is not a valid hash type}) }
  end

  context 'when the third argument is not a string' do
    it { is_expected.to run.with_params('password', 'sha-256', []).and_raise_error(ArgumentError, %r{third argument must be a string}) }
    it { is_expected.to run.with_params('password', 'sha-256', {}).and_raise_error(ArgumentError, %r{third argument must be a string}) }
    it { is_expected.to run.with_params('password', 'sha-256', 1).and_raise_error(ArgumentError, %r{third argument must be a string}) }
    it { is_expected.to run.with_params('password', 'sha-256', true).and_raise_error(ArgumentError, %r{third argument must be a string}) }
  end

  context 'when the third argument is empty' do
    it { is_expected.to run.with_params('password', 'sha-512', '').and_raise_error(ArgumentError, %r{third argument must not be empty}) }
  end

  context 'when the third argument contains invalid characters' do
    it { is_expected.to run.with_params('password', 'sha-512', 'one%').and_raise_error(ArgumentError, %r{characters in salt must be in the set}) }
    it { is_expected.to run.with_params('password', 'bcrypt', '1234').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt-a', '1234').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt-x', '1234').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt-y', '1234').and_raise_error(ArgumentError, %r{characters in salt must match}) }
  end

  context 'when the third argument has an invalid strength parameter for bcrypt' do
    it { is_expected.to run.with_params('password', 'bcrypt', '03$salt.salt.salt.salt.sa').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt-a', '03$salt.salt.salt.salt.sa').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt-x', '03$salt.salt.salt.salt.sa').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt-y', '03$salt.salt.salt.salt.sa').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt', '32$salt.salt.salt.salt.sa').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt-a', '32$salt.salt.salt.salt.sa').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt-x', '32$salt.salt.salt.salt.sa').and_raise_error(ArgumentError, %r{characters in salt must match}) }
    it { is_expected.to run.with_params('password', 'bcrypt-y', '32$salt.salt.salt.salt.sa').and_raise_error(ArgumentError, %r{characters in salt must match}) }
  end

  context 'when running on a platform with a weak String#crypt implementation' do
    before(:each) { allow_any_instance_of(String).to receive(:crypt).with('$1$1').and_return('a bad hash') } # rubocop:disable RSpec/AnyInstance : Unable to find a viable replacement

    it { is_expected.to run.with_params('password', 'sha-512', 'salt').and_raise_error(Puppet::ParseError, %r{system does not support enhanced salts}) }
  end

  begin
    require 'etc'
    if Etc.confstr(Etc::CS_GNU_LIBC_VERSION) =~ %r{(\d+\.\d+)} && Puppet::Util::Package.versioncmp(Regexp.last_match(1), '2.28') >= 0
      context 'when running on platform with bcrypt' do
        it { is_expected.to run.with_params('password', 'bcrypt', '05$salt.salt.salt.salt.sa').and_return('$2b$05$salt.salt.salt.salt.sO5QUgeeLRANZyvfNiKJW5amLo3cVD8nW') }
        it { is_expected.to run.with_params('password', 'bcrypt-a', '05$salt.salt.salt.salt.sa').and_return('$2a$05$salt.salt.salt.salt.sO5QUgeeLRANZyvfNiKJW5amLo3cVD8nW') }
        it { is_expected.to run.with_params('password', 'bcrypt-x', '05$salt.salt.salt.salt.sa').and_return('$2x$05$salt.salt.salt.salt.sO5QUgeeLRANZyvfNiKJW5amLo3cVD8nW') }
        it { is_expected.to run.with_params('password', 'bcrypt-y', '05$salt.salt.salt.salt.sa').and_return('$2y$05$salt.salt.salt.salt.sO5QUgeeLRANZyvfNiKJW5amLo3cVD8nW') }
      end
    else
      pending('Only testing bcrypt results on glibc 2.28 and later')
    end
  rescue NameError
    pending('Only testing bcrypt results on glibc')
  end

  if RUBY_PLATFORM == 'java' || 'test'.crypt('$1$1') == '$1$1$Bp8CU9Oujr9SSEw53WV6G.'
    describe 'on systems with enhanced salts support' do
      it { is_expected.to run.with_params('password', 'md5', 'salt').and_return('$1$salt$qJH7.N4xYta3aEG/dfqo/0') }
      it { is_expected.to run.with_params('password', 'sha-256', 'salt').and_return('$5$salt$Gcm6FsVtF/Qa77ZKD.iwsJlCVPY0XSMgLJL0Hnww/c1') }
      it { is_expected.to run.with_params('password', 'sha-512', 'salt').and_return('$6$salt$IxDD3jeSOb5eB1CX5LBsqZFVkJdido3OUILO5Ifz5iwMuTS4XMS130MTSuDDl3aCI6WouIL9AjRbLCelDCy.g.') }
    end

    if Puppet::Util::Package.versioncmp(Puppet.version, '4.7.0') >= 0
      describe 'when arguments are sensitive' do
        it { is_expected.to run.with_params(Puppet::Pops::Types::PSensitiveType::Sensitive.new('password'), 'md5', 'salt').and_return('$1$salt$qJH7.N4xYta3aEG/dfqo/0') }
        it {
          is_expected.to run.with_params(Puppet::Pops::Types::PSensitiveType::Sensitive.new('password'), 'md5', Puppet::Pops::Types::PSensitiveType::Sensitive.new('salt'))
                            .and_return('$1$salt$qJH7.N4xYta3aEG/dfqo/0')
        }
        it { is_expected.to run.with_params('password', 'md5', Puppet::Pops::Types::PSensitiveType::Sensitive.new('salt')).and_return('$1$salt$qJH7.N4xYta3aEG/dfqo/0') }
      end
    end
  end
end
