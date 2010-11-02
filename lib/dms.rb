module DMS
  require 'httparty'
  require 'openssl'
  require 'base64'
  
  autoload :API, 'dms/api'
  autoload :Node, 'dms/node'
  
  class RecordNotFound < RuntimeError; end
  
  class << self
    
    def config
      @config ||= {
        :api_access_key => "",
        :api_token      => "",
        :base_uri       => "http://dms.fourcubed.com"
      }
    end
    
    def get(slug)
      response = DMS::API.find(slug)
      if code == 404
        raise RecordNotFound.new(response.body)
      else
        DMS::Node.new(response.parsed_response)
      end
    end
  end
end