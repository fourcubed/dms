module DMS
  class Connection < ActiveResource::Connection
    
    def get(path, headers = {})
      super(merge_signature_to_path(:get, path), headers)
    end

    def delete(path, headers = {})
      super(merge_signature_to_path(:delete, path), headers)
    end

    def put(path, body = '', headers = {})
      super(merge_signature_to_path(:put, path), body, headers)
    end

    def post(path, body = '', headers = {})
      super(merge_signature_to_path(:post, path), body, headers)
    end
    
    private
      def merge_signature_to_path(request_method, path)
        path, query = path.split("?")
        timestamp   = Time.now.to_i.to_s
        signature   = CGI::escape(generate_signature(request_method, path, timestamp))
        params      = "?#{query.blank? ? "" : "#{query}&" }api_token=#{DMS.config[:api_token].to_s}&timestamp=#{timestamp}&signature=#{signature}"
        
        path + params
      end
    
      def generate_signature(request_method, path, timestamp) 
        data = DMS.config[:api_token].to_s + request_method.to_s.upcase + path +  timestamp
        signature = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, DMS.config[:api_access_key].to_s, data)
        Base64.encode64(signature).chomp 
      end
  end
end