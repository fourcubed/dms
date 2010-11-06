module DMS
  class Node
    attr_reader :name
    attr_reader :type
    attr_reader :text
    attr_reader :html
    attr_reader :expires_on
    
    def initialize(response)
      @response = response
      hash = @response.parsed_response.values.first
      @name = hash["name"]
      @type = hash["type"]
      @text = hash["body"]
      @html = hash["html"]
      @expires_on = Date.parse(hash["expires_on"]) rescue nil
    end
  end
  
end