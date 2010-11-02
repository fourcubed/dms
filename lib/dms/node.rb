module DMS
  class Node
    attr_reader :name
    attr_reader :type
    attr_reader :text
    attr_reader :html
    
    def initialize(response)
      @response = response
      @name = @response.parsed_response.values.first["name"]
      @type = @response.parsed_response.values.first[:type]
      @text = @response.parsed_response.values.first[:text]
      @html = @response.parsed_response.values.first[:html]
    end
  end
  
end