require 'puppet/network/http_pool'

module PuppetX
  module Puppetlabs
    class HttpValidator
      attr_reader :http_server
      attr_reader :http_port
      attr_reader :use_ssl
      attr_reader :test_path
      attr_reader :test_headers

      def initialize(http_server, http_port, use_ssl, test_path)
        @http_server  = http_server
        @http_port    = http_port
        @use_ssl      = use_ssl
        @test_path    = test_path
        @test_headers = { "Accept" => "application/json" }
      end

      # Utility method; attempts to make an http/https connection to a server.
      # This is abstracted out into a method so that it can be called multiple times
      # for retry attempts.
      #
      # @return true if the connection is successful, false otherwise.
      def attempt_connection
        conn = Puppet::Network::HttpPool.http_instance(http_server, http_port, use_ssl)

        response = conn.get(test_path, test_headers)
        unless response.kind_of?(Net::HTTPSuccess)
          Puppet.notice "Unable to connect to the server (http#{use_ssl ? "s" : ""}://#{http_server}:#{http_port}): [#{response.code}] #{response.msg}"
          return false
        end
        return true
      rescue Exception => e
        Puppet.notice "Unable to connect to the server (http#{use_ssl ? "s" : ""}://#{http_server}:#{http_port}): #{e.message}"
        return false
      end
    end
  end
end

