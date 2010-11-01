module DMS
  class Node
    include HTTParty
    format :xml
    base_uri DMS.config[:base_uri]
    default_params :api_token => DMS.config[:api_token]
    
    class << self
      
      def generate_signature(request_method, path, timestamp) 
        data = DMS.config[:api_token].to_s + request_method.to_s.upcase + path +  timestamp
        signature = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, DMS.config[:api_access_key].to_s, data)
        Base64.encode64(signature).chomp 
      end
      
      def get(path, options = {})
        timestamp = Time.now.to_i.to_s
        signature = CGI::escape(generate_signature(:get, path, timestamp))
        default_params :timestamp => timestamp, :signature => signature
        super(path, options)
      end
    end
  end
end