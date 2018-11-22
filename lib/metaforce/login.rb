module Metaforce
  class Login
    def initialize(username, password, security_token, host = nil)
      @username = username
      @password = password
      @security_token = security_token
      @host = host
    end

    # Public: Perform the login request.
    #
    # Returns a hash with the session id and server urls.
    def login
      response = client.call :login, :message => { :username => username, :password => password }
      response.body[:login_response][:result]
    end

  private

    # Internal: Savon client.
    def client
      @client ||= Savon.client(wsdl: Metaforce.configuration.partner_wsdl, endpoint: Metaforce.configuration.endpoint(host: host), ssl_verify_mode: :peer, ssl_version: :TLSv1_2, logger: Metaforce.configuration.logger, log: Metaforce.configuration.log)
    end

    # Internal: Usernamed passed in from options.
    def username
      @username
    end

    # Internal: Password + Security Token combined.
    def password
      [@password, @security_token].join('')
    end

    # Internal: Host passed in from options.
    def host
      @host
    end
  end
end
