$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..","..",".."))
require 'puppet_x/puppetlabs/tcp_validator'

# This file contains a provider for the resource type `tcp_conn_validator`,
# which validates the TCP connection.

Puppet::Type.type(:tcp_conn_validator).provide(:tcp_port) do
  desc "A provider for the resource type `tcp_conn_validator`,
        which validates the tcp connection."

  def exists?
    start_time = Time.now
    timeout = resource[:timeout]

    success = validator.attempt_connection

    while success == false && ((Time.now - start_time) < timeout)
      Puppet.debug("Failed to connect to the server; sleeping 4 seconds before retry")
      sleep 4
      success = validator.attempt_connection
    end

    if success
      Puppet.debug("Connected to the server in #{Time.now - start_time} seconds.")
    else
      Puppet.notice("Failed to connect to the server within timeout window of #{timeout} seconds; giving up.")
    end

    success
  end

  def create
    # If `#create` is called, that means that `#exists?` returned false, which
    # means that the connection could not be established... so we need to
    # cause a failure here.
    raise Puppet::Error, "Unable to connect to the  server! (#{@validator.tcp_server}:#{@validator.tcp_port})"
  end

  private

  # @api private
  def validator
    @validator ||= PuppetX::Puppetlabs::TcpValidator.new(resource[:name], resource[:server], resource[:port])
  end

end

