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
    
    def get(slug)
      resource, *path = slug.split("/")
      case resource
      when "documents"
        DMS::Document.find(resource.join("/"))
      when "tables"
        DMS::Table.find(resource.join("/"))
      else
        nil
      end
    end
  end
end