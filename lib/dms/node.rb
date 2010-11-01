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
      
      def find(slug)
        path      = slug_to_path(slug)
        timestamp = Time.now.to_i.to_s
        signature = generate_signature(:get, path, timestamp)
        get(path, :query => { :timestamp => timestamp, :signature => signature }).parsed_response
      end
      
      def slug_to_path(slug)
        File.join("/", slug) + ".xml"
      end
    end
  end
end