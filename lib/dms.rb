module DMS
  require 'httparty'
  require 'openssl'
  require 'base64'
  require 'cgi'
  
  autoload :Node, 'dms/node'
  
  class << self
    
    def config
      @config ||= {
        :api_access_key => "",
        :api_token      => "",
        :base_uri       => "http://dms.fourcubed.com"
      }
    end
  end
end