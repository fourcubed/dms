module DMS
  require 'active_resource'
  require 'openssl'
  require 'base64'

  autoload :Connection,     'dms/connection'
  autoload :Resource,       'dms/resource'
  autoload :Document,       'dms/document'
  autoload :Table,          'dms/table'
  
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
      path = path.join("/")
      case resource
      when "documents"
        DMS::Document.find(path)
      when "tables"
        DMS::Table.find(path)
      else
        nil
      end
    end
  end
end