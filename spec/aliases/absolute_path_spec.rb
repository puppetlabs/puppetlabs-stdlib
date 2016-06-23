require 'spec_helper'

describe 'test::absolute_path', type: :class do
  describe 'valid paths handling' do
    %w{
      C:/
      C:\\
      C:\\WINDOWS\\System32
      C:/windows/system32
      X:/foo/bar
      X:\\foo\\bar
      \\\\host\\windows
      //host/windows
      /
      /var/tmp
      /var/opt/../lib/puppet
    }.each do |value|
      describe value.inspect do
        let(:params) {{ value: value }}
        it { is_expected.to compile }
      end
    end
  end

  describe 'invalid path handling' do
    context 'garbage inputs' do
      [
        nil,
        [ nil ],
        [ nil, nil ],
        { 'foo' => 'bar' },
        { },
        '',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Stdlib::Compat::Absolute_path/) }
        end
      end
    end

    context 'relative paths' do
      %w{
        relative1
        .
        ..
        ./foo
        ../foo
        etc/puppetlabs/puppet
        opt/puppet/bin
        relative\\windows
      }.each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Stdlib::Compat::Absolute_path/) }
        end
      end
    end
  end
end
