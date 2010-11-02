module DMS
  class API
    include HTTParty
    
    base_uri "http://dms.fourcubed.com"
    format :xml
    
    attr_accessor :api_token
    attr_accessor :api_access_key
    attr_accessor :format
    
    def initialize(options = {})
      @api_token = options[:api_token].to_s
      @api_access_key = options[:api_access_key].to_s
      self.class.default_params(:api_token => @api_token)
    end
    
    def generate_signature(request_method, path, timestamp) 
      data = @api_token + request_method.to_s.upcase + path + timestamp
      signature = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, @api_access_key, data)
      Base64.encode64(signature).chomp 
    end
    
    def format_extension
      ".#{self.class.format.to_s}"
    end
    
    def slug_to_path(slug)
      File.join("/", slug.to_s) + format_extension
    end
    
    def generate_timestamp
      Time.now.to_i.to_s
    end
    
    def get(slug)
      raise "slug can't be blank!" if slug.blank?
      
      path      = slug_to_path(slug)
      timestamp = generate_timestamp
      signature = generate_signature(:get, path, timestamp)
      self.class.get(path, :query => { :timestamp => timestamp, :signature => signature })
    end
  end
end