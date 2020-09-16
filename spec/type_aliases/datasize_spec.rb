require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Datasize' do
    describe 'valid handling' do
      ['42b', '42B', '42k', '42K', '42m', '42M', '42g', '42G', '42t', '42T',
       '42kb', '42Kb', '42mb', '42Mb', '42gb', '42Gb', '42Tb', '42Tb',
       '42kB', '42KB', '42mB', '42MB', '42gB', '42GB', '42TB', '42TB'].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid path handling' do
      context 'garbage inputs' do
        [
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          1024,
          '1024',
          '1024byte',
          '1024bit',
          '1024Gig',
          '1024Meg',
          '1024BM',
          '1024bg',
          '1024Meb',
          'asdaSddasd',
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
