module DMS
  class Node
    include HTTParty
    format :xml
    base_uri DMS.config[:base_uri]
    default_params :api_token => DMS.config[:api_token]
    
    class << self
      
      def generate_signature(request_method, path, timestamp) 
        data = DMS.config[:api_token].to_s + request_method.to_s.upcase + path + timestamp
        signature = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, DMS.config[:api_access_key].to_s, data)
        Base64.encode64(signature).chomp 
      end
      
      def generate_timestamp
        Time.now.to_i.to_s
      end
      
      def find(slug)
        raise "slug can't be blank!" if slug.blank?
        
        path      = slug_to_path(slug)
        timestamp = generate_timestamp
        signature = generate_signature(:get, path, timestamp)
        get(path, :query => { :timestamp => timestamp, :signature => signature }).parsed_response
      end
      
      def slug_to_path(slug)
        File.join("/", slug.to_s) + ".xml"
      end
    end
  end
end