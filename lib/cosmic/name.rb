module Cosmic
  class Name
    attr_accessor :elements
    
    def initialize(*elements)
      @elements = elements.flatten
    end

    def to_s
      @elements.map(&:capitalize).join(' ')
    end

    def self.generate(model, element_count=3)
      name_elements = []

      element_count.times do |i|
        index_elements = model.send(:name_elements, i) - name_elements
        name_elements << index_elements.sample
      end

      Name.new(name_elements)
    end
  end
end
