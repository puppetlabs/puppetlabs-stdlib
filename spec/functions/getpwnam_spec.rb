# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::getpwnam' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{expects 1 argument, got none}i) }

  it {
    passwd_entry = Etc::Passwd.new(
       'steve',
       'x',
       1000,
       1001,
       'Steve',
       '/home/steve',
       '/bin/fish',
     )
    allow(Etc).to receive(:getpwnam).with(anything, anything).and_call_original
    allow(Etc).to receive(:getpwnam).with('steve').and_return(passwd_entry)
    is_expected.to run.with_params('steve').and_return(
      {
        'name' => 'steve',
        'passwd' => 'x',
        'uid' => 1000,
        'gid' => 1001,
        'gecos' => 'Steve',
        'dir' => '/home/steve',
        'shell' => '/bin/fish'
      },
    )
  }

  it { is_expected.to run.with_params('notexisting').and_raise_error(ArgumentError, %r{can't find user for notexisting}i) }
end
