#! /usr/bin/env ruby -S rspec
require 'spec_helper'

provider_class = Puppet::Type.type(:file_line).provider(:ruby)
# These tests fail on windows when run as part of the rake task. Individually they pass
describe provider_class, :unless => Puppet::Util::Platform.windows? do
  include PuppetlabsSpec::Files

  let :tmpfile do
    tmpfilename("file_line_test")
  end
  let :content do
    ''
  end
  let :params do
    { }
  end
  let :resource do
    Puppet::Type::File_line.new( {
      name: 'foo',
      path: tmpfile,
      line: 'foo',
    }.merge(params))
  end
  let :provider do
    provider_class.new(resource)
  end
  before :each do
    File.open(tmpfile, 'w') do |fh|
      fh.write(content)
    end
  end

  describe "line parameter" do
    context "line exists" do
      let(:content) { 'foo' }
      it 'detects the line' do
        expect(provider.exists?).to be_truthy
      end
    end
    context "line does not exist" do
      let(:content) { 'foo bar' }
      it 'requests changes' do
        expect(provider.exists?).to be_falsy
      end
      it 'appends the line' do
        provider.create
        expect(File.read(tmpfile).chomp).to eq("foo bar\nfoo")
      end
    end
  end
  describe "match parameter" do
    context "does not match line" do
      let(:params) { { match: '^bar' } }
      context "line does not exist" do
        describe "replacing" do
          let(:content) { "foo bar\nbar" }
          it 'requests changes' do
            expect(provider.exists?).to be_falsy
          end
          it 'replaces the match' do
            provider.create
            expect(File.read(tmpfile).chomp).to eq("foo bar\nfoo")
          end
        end
        describe "appending" do
          let(:params) { super().merge({ replace: false }) }
          let(:content) { "foo bar\nbar" }
          it 'does not request changes' do
            expect(provider.exists?).to be_truthy
          end
        end
      end
      context "line exists" do
        let(:content) { "foo\nbar" }
        it 'detects the line' do
          expect(provider.exists?).to be_truthy
        end
      end
    end
    context "matches line" do 
      let(:params) { { match: '^foo' } }
      context "line exists" do
        let(:content) { "foo\nbar" }
        it 'detects the line' do
          expect(provider.exists?).to be_truthy
        end
      end
      context "line does not exist" do
        let(:content) { "foo bar\nbar" }
        it 'requests changes' do
          expect(provider.exists?).to be_falsy
        end
        it 'replaces the match' do
          provider.create
          expect(File.read(tmpfile).chomp).to eq("foo\nbar")
        end
      end
    end
  end
  describe 'append_on_no_match' do
    let(:params) { {
      append_on_no_match: false,
      match: '^foo1$',
    } }
    context 'when matching' do
      let(:content) { "foo1\nbar" }
      it 'requests changes' do
        expect(provider.exists?).to be_falsy
      end
      it 'replaces the match' do
        provider.create
        expect(File.read(tmpfile).chomp).to eql("foo\nbar")
      end
    end
    context 'when not matching' do
      let(:content) { "foo3\nbar" }
      it 'does not affect the file' do
        expect(provider.exists?).to be_truthy
      end
    end
  end
  describe 'replace_all_matches_not_matching_line' do
    context 'when replace is false' do
      let(:params) { {
        replace_all_matches_not_matching_line: true,
        replace: false,
      } }
      it 'raises an error' do
        expect { provider.exists? }.to raise_error(Puppet::Error, /replace must be true/)
      end
    end
    context 'when match matches line' do
      let(:params) { {
        replace_all_matches_not_matching_line: true,
        match: '^foo',
        multiple: true,
      } }
      context 'when there are more matches than lines' do
        let(:content) { "foo\nfoo bar\nbar\nfoo baz" }
        it 'requests changes' do
          expect(provider.exists?).to be_falsy
        end
        it 'replaces the matches' do
          provider.create
          expect(File.read(tmpfile).chomp).to eql("foo\nfoo\nbar\nfoo")
        end
      end
      context 'when there are the same matches and lines' do
        let(:content) { "foo\nfoo\nbar" }
        it 'does not request changes' do
          expect(provider.exists?).to be_truthy
        end
      end
    end
    context 'when match does not match line' do
      let(:params) { {
        replace_all_matches_not_matching_line: true,
        match: '^bar',
        multiple: true,
      } }
      context 'when there are more matches than lines' do
        let(:content) { "foo\nfoo bar\nbar\nbar baz" }
        it 'requests changes' do
          expect(provider.exists?).to be_falsy
        end
        it 'replaces the matches' do
          provider.create
          expect(File.read(tmpfile).chomp).to eql("foo\nfoo bar\nfoo\nfoo")
        end
      end
      context 'when there are the same matches and lines' do
        let(:content) { "foo\nfoo\nbar\nbar baz" }
        it 'requests changes' do
          expect(provider.exists?).to be_falsy
        end
        it 'replaces the matches' do
          provider.create
          expect(File.read(tmpfile).chomp).to eql("foo\nfoo\nfoo\nfoo")
        end
      end
      context 'when there are no matches' do
        let(:content) { "foo\nfoo bar" }
        it 'does not request changes' do
          expect(provider.exists?).to be_truthy
        end
      end
      context 'when there are no matches or lines' do
        let(:content) { "foo bar" }
        it 'requests changes' do
          expect(provider.exists?).to be_falsy
        end
        it 'appends the line' do
          provider.create
          expect(File.read(tmpfile).chomp).to eql("foo bar\nfoo")
        end
      end
    end
  end
  describe 'match_for_absence' do
  end
  describe 'customer use cases' do
    describe 'MODULES-5003' do
      let(:params) { {
        line: "*\thard\tcore\t0",
        match: "^[ \t]*\\*[ \t]+hard[ \t]+core[ \t]+.*",
        multiple: true,
      } }
      context 'no lines' do
        let(:content) { "*	hard	core	90\n*	hard	core	10\n" }
        it 'requests changes' do
          expect(provider.exists?).to be_falsy
        end
        it 'replaces the matches' do
          provider.create
          expect(File.read(tmpfile).chomp).to eq("*	hard	core	0\n*	hard	core	0")
        end
      end
      context 'one match, one line' do
        let(:content) { "*	hard	core	90\n*	hard	core	0\n" }
        describe 'just ensure the line exists' do
          it 'does not request changes' do
            expect(provider.exists?).to be_truthy
          end
        end
        describe 'replace all matches, even when line exists' do
          let(:params) { super().merge(replace_all_matches_not_matching_line: true) }
          it 'requests changes' do
            expect(provider.exists?).to be_falsy
          end
          it 'replaces the matches' do
            provider.create
            expect(File.read(tmpfile).chomp).to eq("*	hard	core	0\n*	hard	core	0")
          end
        end
      end
    end
    describe 'MODULES-5651' do
      let(:params) { {
        line: 'LogLevel=notice',
        match: '^#LogLevel$',
      } }
      context "match, no line" do
        let(:content) { "#LogLevel\nstuff" }
        it 'requests changes' do
          expect(provider.exists?).to be_falsy
        end
        it 'replaces the match' do
          provider.create
          expect(File.read(tmpfile).chomp).to eq("LogLevel=notice\nstuff")
        end
      end
      context "match, line" do
        let(:content) { "#Loglevel\nLogLevel=notice\nstuff" }
        it 'does not request changes' do
          expect(provider.exists?).to be_truthy
        end
      end
      context "no match, line" do
        let(:content) { "LogLevel=notice\nstuff" }
        it 'does not request changes' do
          expect(provider.exists?).to be_truthy
        end
      end
    end
  end
  describe "#create" do
    context "when adding" do
    end
    context 'when replacing' do
      let :params do
        {
          line: 'foo = bar',
          match: '^foo\s*=.*$',
          replace: false,
        }
      end
      let(:content) { "foo1\nfoo=blah\nfoo2\nfoo3" }

      it 'should not replace the matching line' do
        expect(provider.exists?).to be_truthy
        provider.create
        expect(File.read(tmpfile).chomp).to eql("foo1\nfoo=blah\nfoo2\nfoo3")
      end
      it 'should append the line if no matches are found' do
        File.open(tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo2")
        end
        expect(provider.exists?).to eql (false)
        provider.create
        expect(File.read(tmpfile).chomp).to eql("foo1\nfoo2\nfoo = bar")
      end
      it 'should raise an error with invalid values' do
        expect {
          @resource = Puppet::Type::File_line.new(
            {
              :name     => 'foo',
              :path     => tmpfile,
              :line     => 'foo = bar',
              :match    => '^foo\s*=.*$',
              :replace  => 'asgadga',
            }
          )
        }.to raise_error(Puppet::Error, /Invalid value "asgadga"\. Valid values are true, false\./)
      end
    end
  end
  describe "#destroy" do
  end
  context "when matching" do
    before :each do
      @resource = Puppet::Type::File_line.new(
        {
          :name  => 'foo',
          :path  => tmpfile,
          :line  => 'foo = bar',
          :match => '^foo\s*=.*$',
        }
      )
      @provider = provider_class.new(@resource)
    end
    describe 'using match' do
      it 'should raise an error if more than one line matches, and should not have modified the file' do
        File.open(tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo=blah\nfoo2\nfoo=baz")
        end
        expect(@provider.exists?).to eql(false)
        expect { @provider.create }.to raise_error(Puppet::Error, /More than one line.*matches/)
        expect(File.read(tmpfile)).to eql("foo1\nfoo=blah\nfoo2\nfoo=baz")
      end

      it 'should replace all lines that matches' do
        @resource = Puppet::Type::File_line.new(
          {
            :name     => 'foo',
            :path     => tmpfile,
            :line     => 'foo = bar',
            :match    => '^foo\s*=.*$',
            :multiple => true,
          }
        )
        @provider = provider_class.new(@resource)
        File.open(tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo=blah\nfoo2\nfoo=baz")
        end
        expect(@provider.exists?).to eql(false)
        @provider.create
        expect(File.read(tmpfile).chomp).to eql("foo1\nfoo = bar\nfoo2\nfoo = bar")
      end

      it 'should replace all lines that match, even when some lines are correct' do
        @resource = Puppet::Type::File_line.new(
          {
            :name     => 'neil',
            :path     => tmpfile,
            :line     => "\thard\tcore\t0\n",
            :match    => '^[ \t]hard[ \t]+core[ \t]+.*',
            :multiple => true,
          }
        )
        @provider = provider_class.new(@resource)
        File.open(tmpfile, 'w') do |fh|
          fh.write("\thard\tcore\t90\n\thard\tcore\t0\n")
        end
        expect(@provider.exists?).to eql(false)
        @provider.create
        expect(File.read(tmpfile).chomp).to eql("\thard\tcore\t0\n\thard\tcore\t0")
      end

      it 'should raise an error with invalid values' do
        expect {
          @resource = Puppet::Type::File_line.new(
            {
              :name     => 'foo',
              :path     => tmpfile,
              :line     => 'foo = bar',
              :match    => '^foo\s*=.*$',
              :multiple => 'asgadga',
            }
          )
        }.to raise_error(Puppet::Error, /Invalid value "asgadga"\. Valid values are true, false\./)
      end

      it 'should replace a line that matches' do
        File.open(tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo=blah\nfoo2")
        end
        expect(@provider.exists?).to eql(false)
        @provider.create
        expect(File.read(tmpfile).chomp).to eql("foo1\nfoo = bar\nfoo2")
      end
      it 'should add a new line if no lines match' do
        File.open(tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo2")
        end
        expect(@provider.exists?).to eql(false)
        @provider.create
        expect(File.read(tmpfile)).to eql("foo1\nfoo2\nfoo = bar\n")
      end
      it 'should do nothing if the exact line already exists' do
        File.open(tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo = bar\nfoo2")
        end
        expect(@provider.exists?).to eql(true)
        @provider.create
        expect(File.read(tmpfile).chomp).to eql("foo1\nfoo = bar\nfoo2")
      end

    end
    describe 'using match+append_on_no_match' do
      context 'when there is a match' do
        it 'should replace line' do
          @resource = Puppet::Type::File_line.new(
            {
              :name               => 'foo',
              :path               => tmpfile,
              :line               => 'inserted = line',
              :match              => '^foo3$',
              :append_on_no_match => false,
            }
          )
          @provider = provider_class.new(@resource)
          File.open(tmpfile, 'w') do |fh|
            fh.write("foo1\nfoo = blah\nfoo2\nfoo = baz")
          end
          expect(@provider.exists?).to be true
          expect(File.read(tmpfile).chomp).to eql("foo1\nfoo = blah\nfoo2\nfoo = baz")
        end
      end
      context 'when there is no match' do
        it 'should not add line after no matches found' do
          @resource = Puppet::Type::File_line.new(
            {
              :name               => 'foo',
              :path               => tmpfile,
              :line               => 'inserted = line',
              :match              => '^foo3$',
              :append_on_no_match => false,
            }
          )
          @provider = provider_class.new(@resource)
          File.open(tmpfile, 'w') do |fh|
            fh.write("foo1\nfoo = blah\nfoo2\nfoo = baz")
          end
          expect(@provider.exists?).to be true
          expect(File.read(tmpfile).chomp).to eql("foo1\nfoo = blah\nfoo2\nfoo = baz")
        end
      end
    end
  end
  context "when match+replace+append_on_no_match" do
  end
  context 'when after' do
    let :resource do
      Puppet::Type::File_line.new(
        {
          :name  => 'foo',
          :path  => tmpfile,
          :line  => 'inserted = line',
          :after => '^foo1',
        }
      )
    end

    let :provider do
      provider_class.new(resource)
    end
    context 'match and after set' do
      shared_context 'resource_create' do
        let(:match) { '^foo2$' }
        let(:after) { '^foo1$' }
        let(:resource) {
          Puppet::Type::File_line.new(
            {
              :name  => 'foo',
              :path  => tmpfile,
              :line  => 'inserted = line',
              :after => after,
              :match => match,
            }
          )
        }
      end
      before :each do
        File.open(tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo2\nfoo = baz")
        end
      end
      describe 'inserts at match' do
        include_context 'resource_create'
        it {
          provider.create
          expect(File.read(tmpfile).chomp).to eq("foo1\ninserted = line\nfoo = baz")
        }
      end
      describe 'inserts a new line after when no match' do
        include_context 'resource_create' do
          let(:match) { '^nevergoingtomatch$' }
        end
        it {
          provider.create
          expect(File.read(tmpfile).chomp).to eq("foo1\ninserted = line\nfoo2\nfoo = baz")
        }
      end
      describe 'append to end of file if no match for both after and match' do
        include_context 'resource_create' do
          let(:match) { '^nevergoingtomatch$' }
          let(:after) { '^stillneverafter' }
        end
        it {
          provider.create
          expect(File.read(tmpfile).chomp).to eq("foo1\nfoo2\nfoo = baz\ninserted = line")
        }
      end
    end
    context 'with one line matching the after expression' do
      before :each do
        File.open(tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo = blah\nfoo2\nfoo = baz")
        end
      end

      it 'inserts the specified line after the line matching the "after" expression' do
        provider.create
        expect(File.read(tmpfile).chomp).to eql("foo1\ninserted = line\nfoo = blah\nfoo2\nfoo = baz")
      end
    end
    context 'with multiple lines matching the after expression' do
      before :each do
        File.open(tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo = blah\nfoo2\nfoo1\nfoo = baz")
        end
      end

      it 'errors out stating "One or no line must match the pattern"' do
        expect { provider.create }.to raise_error(Puppet::Error, /One or no line must match the pattern/)
      end

      it 'adds the line after all lines matching the after expression' do
        @resource = Puppet::Type::File_line.new(
          {
            :name     => 'foo',
            :path     => tmpfile,
            :line     => 'inserted = line',
            :after    => '^foo1$',
            :multiple => true,
          }
        )
        @provider = provider_class.new(@resource)
        expect(@provider.exists?).to eql (false) 
        @provider.create
        expect(File.read(tmpfile).chomp).to eql("foo1\ninserted = line\nfoo = blah\nfoo2\nfoo1\ninserted = line\nfoo = baz")
      end
    end
    context 'with no lines matching the after expression' do
      let :content do
        "foo3\nfoo = blah\nfoo2\nfoo = baz\n"
      end

      before :each do
        File.open(tmpfile, 'w') do |fh|
          fh.write(content)
        end
      end

      it 'appends the specified line to the file' do
        provider.create
        expect(File.read(tmpfile)).to eq(content << resource[:line] << "\n")
      end
    end
  end
  context "when removing with a line" do
    before :each do
      # TODO: these should be ported over to use the PuppetLabs spec_helper
      #  file fixtures once the following pull request has been merged:
      # https://github.com/puppetlabs/puppetlabs-stdlib/pull/73/files
      @resource = Puppet::Type::File_line.new(
        {
          :name   => 'foo',
          :path   => tmpfile,
          :line   => 'foo',
          :ensure => 'absent',
        }
      )
      @provider = provider_class.new(@resource)
    end
    it 'should remove the line if it exists' do
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2")
    end
    it 'should remove the line without touching the last new line' do
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2\n")
      end
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2\n")
    end
    it 'should remove any occurence of the line' do
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2\nfoo\nfoo")
      end
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2\n")
    end
    it 'example in the docs' do
      @resource = Puppet::Type::File_line.new(
        {
          :name   => 'bashrc_proxy',
          :ensure => 'absent',
          :path   => tmpfile,
          :line   => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
        }
      )
      @provider = provider_class.new(@resource)
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo2\nexport HTTP_PROXY=http://squid.puppetlabs.vm:3128\nfoo4\n")
      end
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2\nfoo4\n")
    end
  end
  context "when removing with a match" do
    before :each do
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'foo',
          :path              => tmpfile,
          :line              => 'foo2',
          :ensure            => 'absent',
          :match             => 'o$',
          :match_for_absence => true,
        }
      )
      @provider = provider_class.new(@resource)
    end

    it 'should find a line to match' do
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      expect(@provider.exists?).to eql (true)
    end

    it 'should remove one line if it matches' do
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2")
    end

    it 'the line parameter is actually not used at all but is silently ignored if here' do
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'foo',
          :path              => tmpfile,
          :line              => 'supercalifragilisticexpialidocious',
          :ensure            => 'absent',
          :match             => 'o$',
          :match_for_absence => true,
        }
      )
      @provider = provider_class.new(@resource)
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      expect(@provider.exists?).to eql (true)
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2")
    end

    it 'and may not be here and does not need to be here' do
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'foo',
          :path              => tmpfile,
          :ensure            => 'absent',
          :match             => 'o$',
          :match_for_absence => true,
        }
      )
      @provider = provider_class.new(@resource)
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      expect(@provider.exists?).to eql (true)
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2")
    end

    it 'should raise an error if more than one line matches' do
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2\nfoo\nfoo")
      end
      expect { @provider.destroy }.to raise_error(Puppet::Error, /More than one line/)
    end

    it 'should remove multiple lines if :multiple is true' do
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'foo',
          :path              => tmpfile,
          :line              => 'foo2',
          :ensure            => 'absent',
          :match             => 'o$',
          :multiple          => true,
          :match_for_absence => true,
        }
      )
      @provider = provider_class.new(@resource)
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2\nfoo\nfoo")
      end
      expect(@provider.exists?).to eql (true)
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2\n")
    end

    it 'should ignore the match if match_for_absence is not specified' do
      @resource = Puppet::Type::File_line.new(
        {
          :name     => 'foo',
          :path     => tmpfile,
          :line     => 'foo2',
          :ensure   => 'absent',
          :match    => 'o$',
        }
      )
      @provider = provider_class.new(@resource)
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      expect(@provider.exists?).to eql (true)
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo\n")
    end

    it 'should ignore the match if match_for_absence is false' do
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'foo',
          :path              => tmpfile,
          :line              => 'foo2',
          :ensure            => 'absent',
          :match             => 'o$',
          :match_for_absence => false,
        }
      )
      @provider = provider_class.new(@resource)
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      expect(@provider.exists?).to eql (true)
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo\n")
    end

    it 'example in the docs' do
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'bashrc_proxy',
          :ensure            => 'absent',
          :path              => tmpfile,
          :line              => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
          :match             => '^export\ HTTP_PROXY\=',
          :match_for_absence => true,
        }
      )
      @provider = provider_class.new(@resource)
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo2\nexport HTTP_PROXY=foo\nfoo4\n")
      end
      expect(@provider.exists?).to eql (true)
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2\nfoo4\n")
    end

    it 'example in the docs showing line is redundant' do
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'bashrc_proxy',
          :ensure            => 'absent',
          :path              => tmpfile,
          :match             => '^export\ HTTP_PROXY\=',
          :match_for_absence => true,
        }
      )
      @provider = provider_class.new(@resource)
      File.open(tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo2\nexport HTTP_PROXY=foo\nfoo4\n")
      end
      expect(@provider.exists?).to eql (true)
      @provider.destroy
      expect(File.read(tmpfile)).to eql("foo1\nfoo2\nfoo4\n")
    end
  end
end
