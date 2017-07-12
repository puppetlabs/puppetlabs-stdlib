require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::puppeturi', type: :class do
    describe 'valid handling' do
      %w(
        puppet:///modules/hello/bla
        puppet:///modules/foo/bar.log
      ).each do |value|
        describe value.inspect do
          let(:params) { { value: value } }
          it { is_expected.to compile }
        end
      end
    end

    describe 'invalid path handling' do
      context 'garbage inputs' do
        [
          nil,
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          '',
          'puppe:///modules/notquiteright.org',
          'puppets:///modules/nah',
          'puppet://modules/nah',
          'puppet:/modules/nah',
          'puppet:///hello/bla',
          '/file/test',
          'https//notrightbutclose.org'
        ].each do |value|
          describe value.inspect do
            let(:params) { { value: value } }
            it { is_expected.to compile.and_raise_error(%r{parameter 'value' expects a match for Stdlib::Puppeturi}) }
          end
        end
      end
    end
  end
end
