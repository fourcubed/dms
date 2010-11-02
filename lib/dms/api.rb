module DMS
  class API
    include HTTParty
    
    base_uri "http://dms.fourcubed.com"
    format :xml
    
    attr_accessor :api_token
    attr_accessor :api_access_key
    
    def initialize(api_token = nil, api_access_key = nil)
      @api_token      = api_token.to_s
      @api_access_key = api_access_key.to_s
    end
    
    def format_extension
      ".#{self.class.format.to_s}"
    end

    def generate_timestamp
      Time.now.to_i.to_s
    end
    
    def slug_to_path(slug)
      File.join("/", slug.to_s) + format_extension
    end
    
    def get(slug)
      response = perform_request(slug)
      if response.code == 200
        DMS::Node.new(response)
      elsif response.code == 401
        raise AuthenticationError.new(response.body)
      elsif response.code == 404
        raise ResourceNotFound.new(response.body)
      else
        raise UnknownError.new(response.body)
      end
    end
    
    private
    
      def generate_signature(request_method, path, timestamp) 
        data = @api_token + request_method.to_s.upcase + path + timestamp
        signature = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, @api_access_key, data)
        Base64.encode64(signature).chomp 
      end
    
      def perform_request(slug)
        raise "slug can't be blank!" if slug.blank?
      
        path      = slug_to_path(slug)
        timestamp = generate_timestamp
        signature = generate_signature(:get, path, timestamp)
        self.class.get(path, :query => { :timestamp => timestamp, :signature => signature, :api_token => @api_token })
      end
  end
end