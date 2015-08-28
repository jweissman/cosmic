require 'forwardable'
module Cosmic
  DEFAULT_NARRATION_DEPTH = 2

  class Printer
    def initialize(model)
      @model = model
    end
  
    def narrate(depth: DEFAULT_NARRATION_DEPTH)
      @narration ||= conduct_narration(@model, depth)
    end
  
    protected
  
    def conduct_narration(current_model, depth)
      narration = current_model.inspect
  
      if depth > 0
        current_model.children.each do |child|
          narration += "\n#{' ' * (10-depth)} - #{conduct_narration(child, depth-1)}"
        end
      end
  
      narration
    end
  end

  module Printable
    extend Forwardable

    def_delegator :printer, :narrate

    def printer
      @printer ||= printer_class.new(self)
    end

    def printer_class
      Printer
    end
  end
end
