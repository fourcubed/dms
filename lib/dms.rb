module DMS
  require 'active_resource'
  require 'openssl'
  require 'base64'

  autoload :Connection,     'dms/connection'
  autoload :Resource,       'dms/resource'
  autoload :Document,       'dms/document'
  
  class << self
    
    def config
      @config ||= {
        :api_access_key => "",
        :api_token      => "",
        :domain_name    => "http://dms.fourcubed.com/"
      }
    end
    
  end
end