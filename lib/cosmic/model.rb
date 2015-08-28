module Cosmic
  class Model
    include Printable
    include Genealogical

    attr_writer :parent

    def initialize(parent: nil, children: [], name: nil) 
      @name     = name
      @parent   = parent
      @children = children

      @descendants = {}
      @ancestors   = {}
    end

    def age;  @age ||= 0 end
    def name; @name ||= generate_name end

    def parent
      return nil if self.class.root_node?

      @parent ||= generate_parent
    end

    def children
      return [] if self.class.leaf_node?

      if @children.empty?
        @children = generate_children
      elsif @children.length < self.class.children_range.begin
        @children = @children + generate_children
      end

      @children
    end


    def descendants(depth: 2)
      return Enumerator.new {} if self.class.leaf_node? || depth <= 0

      descendants_enumerator = Enumerator.new do |y|
        children.each { |child| y << child }
        children.map do |child|
          child.descendants(depth: depth - 1).each { |c| y << c }
        end
      end

      return descendants_enumerator
    end

    def ancestors(depth: 2)
      if parent.nil? || depth <= 0
        []
      elsif @ancestors.has_key?(depth)
        @ancestors[depth]
      else
        @ancestors[depth] = ([parent] + parent.ancestors(depth: depth - 1)).flatten
      end
    end

    def siblings
      parent.nil? ? [] : parent.children - [self] 
    end

    def root
      return nil if self.class.root_node?
      ancestors(depth: 20).lazy.detect { |a| a.class.root_node? }
    end

    def leaves
      return [] if self.class.leaf_node?
      descendants(depth: 20).lazy.select { |d| d.class.leaf_node? }
    end

    def ancestor_name_elements(depth=1)
      ancestors(depth: depth).map(&:name).map(&:elements).flatten
    end

    # def printer
    #   @printer ||= Printer.new
    # end

    # def narrate(depth: 2)
    #   printer.narrate(self, depth: depth)
    # end

    def inspect; "a #{type} named '#{name}'" end

    protected
    def type; self.class.name.split('::').last.downcase end

    def naming_dictionary
      raise "Override Model#naming_dictionary in #{self.name.to_s}"
    end

    def name_elements(i)
      naming_dictionary.entries
    end

    def self.child_type; raise "Override Model#child_type in #{self.class.name.to_s}" end

    def self.root_node?; false end
    def self.leaf_node?; false end

    def self.children_range; (3..10) end

    def self.name_element_range; (2..4) end


    def generate_parent
      return if self.class.root_node?
      self.class.parent_type.new(children: [self])
    end

    def generate_children(n=self.class.children_range.to_a.sample)
      return [] if self.class.leaf_node?
      Array.new(n) { self.class.child_type.new(parent: self) }
    end

    def generate_name
      Name.generate(self, self.class.name_element_range.to_a.sample)
    end
  end
end
