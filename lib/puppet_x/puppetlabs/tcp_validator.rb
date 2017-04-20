require 'socket'
require 'timeout'
require 'ipaddr'
require 'uri'

module PuppetX
  module Puppetlabs
    class TcpValidator
      attr_reader :tcp_server
      attr_reader :tcp_port

      def initialize(tcp_resource_name, tcp_server, tcp_port)
        begin
          # NOTE (spredzy) : By relying on the uri module
          # we rely on its well tested interface to parse
          # both IPv4 and IPv6 based URL with a port specified.
          # Unfortunately URI needs a scheme, hence the http
          # string here to make the string URI compliant.
          uri = URI("http://#{tcp_resource_name}")
          @tcp_server = IPAddr.new(uri.host).to_s
          @tcp_port = uri.port
        rescue
          @tcp_server = IPAddr.new(tcp_server).to_s
          @tcp_port   = tcp_port
        end
      end

      # Utility method; attempts to make a tcp connection to the specified server.
      # This is abstracted out into a method so that it can be called multiple times
      # for retry attempts.
      #
      # @return true if the connection is successful, false otherwise.
      def attempt_connection
        Timeout::timeout(Puppet[:configtimeout]) do
          begin
            TCPSocket.new(@tcp_server, @tcp_port).close
            true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e
            Puppet.debug "Unable to connect to tcp server (#{@tcp_server}:#{@tcp_port}): #{e.message}"
            false
          end
        end
      rescue Timeout::Error
        false
      end
    end
  end
end
