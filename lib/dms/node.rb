module DMS
  class Node
    attr_reader :name
    attr_reader :type
    attr_reader :text
    attr_reader :html
    
    def initialize(hash)
      hash = hash.values.first
      @name = hash[:name]
      @type = hash[:type]
      @text = hash[:body]
      @html = hash[:body]
    end
  end
end