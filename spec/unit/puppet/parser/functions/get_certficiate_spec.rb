#!/usr/bin/env rspec

require 'spec_helper'
require 'net/http'
require 'thread'
require 'fileutils'

describe "the get_certificate function" do
  include PuppetSpec::Files

  before :all do
    @sslcert = File.read("spec/master_config/ssl/ca/signed/bob@mydomain.com.pem")

    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("get_certificate").should == "function_get_certificate"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { @scope.function_get_certificate([]) }.should(raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if the argument is empty" do
    lambda { @scope.function_get_certificate([""]) }.should(raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if the argument contains strange characters" do
    lambda { @scope.function_get_certificate(["%^&"]) }.should(raise_error(Puppet::ParseError))
  end

  it "should return a valid certificate if CA is local" do
    Puppet[:ca] = true
    Puppet[:signeddir] = "spec/master_config/ssl/ca/signed/"
    result = @scope.function_get_certificate(["bob@mydomain.com"])
    result.should(eq(@sslcert))
  end

  it "should throw an error if CN is missing and CA is local" do
    Puppet[:ca] = true
    Puppet[:signeddir] = "spec/master_config/ssl/ca/signed/"
    result = @scope.function_get_certificate(["missing@mydomain.com"])
    result.should(eq(:undef))
  end

  it "should return a valid certificate if CA is remote" do
    Puppet[:ca] = false
    Puppet[:ssldir] = "spec/master_config/ssl"
    Puppet[:certname] = "puppetmaster"

    # Mock return
    require 'ostruct'
    http = OpenStruct.new
    http.body = @sslcert
    http.code = "200"
   
    # Intercept http start call
    Net::HTTP.any_instance.expects(:start).returns(http)

    result = @scope.function_get_certificate(["bob@mydomain.com"])
    result.should(eq(@sslcert))
  end

  it "should throw an error if CN doesn't exist and CA is remote (stubbed)" do
    Puppet[:ca] = false
    Puppet[:ssldir] = "spec/master_config/ssl"
    Puppet[:certname] = "puppetmaster"

    # Mock return
    require 'ostruct'
    http = OpenStruct.new
    http.code = "404"
   
    # Intercept http start call
    Net::HTTP.any_instance.expects(:start).returns(http)

    result = @scope.function_get_certificate(["missing@mydomain.com"])
    result.should(eq(:undef))
  end

  describe "real puppetmaster" do
    before :all do
      # Prepare fixture for puppetmaster
      @master_tmp = tmpdir("get_certificate") + "/master_config"
      FileUtils.cp_r("spec/master_config",@master_tmp)

      # Fork and start a puppetmaster
      master_config = [
        "--config=/dev/null",
        "--logdest=#{@master_tmp}/var/log/logfile",
        "--confdir=#{@master_tmp}",
        "--no-daemonize",
        "--masterport=9354",
        "--bindaddress=127.0.0.1",
        "--vardir=#{@master_tmp}/var",
        "--ssldir=#{@master_tmp}/ssl",
        "--certname=puppetmaster",
        "--user=#{ENV["USER"]}",
#        "--debug",
      ]
      @master = Process.fork do
        cmd = Puppet::Util::CommandLine.new("master", master_config)
        Puppet::Plugins.on_application_intialization(:application_object => cmd)
        app = Puppet::Application.find("master").new(cmd)
        app.run
      end

      # Wait 1 second for puppetmatser setup
      # TODO: must be a better wait to check if master
      # is listening first before proceeding.
      sleep 1

      Puppet::Parser::Functions.autoloader.loadall
    end

    before :each do
      # Standard puppet setup for each test
      Puppet[:ca] = false
      Puppet[:ssldir] = "#{@master_tmp}/ssl"
      Puppet[:certname] = "puppetmaster"
      Puppet[:ca_port] = "9354"
      Puppet[:ca_server] = "127.0.0.1"
    end

    after :all do
      # Kill and reap puppetmaster
      Process.kill("TERM", @master)
      Process.wait(@master)
    end

    it "should return a valid certificate if CA is remote" do
      result = @scope.function_get_certificate(["bob@mydomain.com"])
      result.should(eq(@sslcert))
    end
  
    it "should throw an error if CN doesn't exist and CA is remote" do
      result = @scope.function_get_certificate(["missing@mydomain.com"])
      result.should(eq(:undef))
    end

    it "should throw a connection refused message if CA is not running on port" do
      Puppet[:ca_port] = "65111"
      lambda { @scope.function_get_certificate(["missing@mydomain.com"]) }.should(raise_error(Puppet::Error))
    end

    it "should raise an exception if connection to CA times out" do
      Puppet[:ca_server] = "10.254.254.254"
      lambda { @scope.function_get_certificate(["missing@mydomain.com", { :conn_timeout => 1}]) }.should(raise_error(Puppet::Error))
    end

  end

end
