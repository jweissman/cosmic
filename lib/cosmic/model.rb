module Cosmic
  class Model
    include Printable

    def self.children_range; (2..3) end
    def self.name_element_range; (1..3) end

    attr_writer :parent

    def initialize(parent: nil, children: [], name: nil) 
      @name     = name
      @parent   = parent
      @children = children
    end

    def age;  @age ||= 0 end
    def name; @name ||= self.generate_name end

    def parent
      @parent ||= self.class.root_node? ? nil : self.class.generate_parent
    end

    def children
      return [] if self.class.leaf_node?

      if @children.empty?
        @children = self.class.generate_children(self)
      elsif @children.length < self.class.children_range.begin
        n = self.class.children_range.end - @children.length
        @children = @children + self.class.generate_children(self,n)
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
      return [] if parent.nil? || depth <= 0
      ([parent] + parent.ancestors(depth: depth - 1)).flatten
    rescue 
      binding.pry
    end

    def siblings
      parent.nil? ? [] : parent.children - [self] 
    end

    def root
      return nil if self.class.root_node?
      ancestors(depth: 25).detect { |a| a.class.root_node? }
    end

    def leaves
      return [] if self.class.leaf_node?
      descendants(depth: 20).lazy.select { |d| d.class.leaf_node? }
    end

    def ancestor_name_elements(depth=4)
      ancestors(depth: depth).map(&:name).map(&:elements).flatten
    end

    def inspect; "a #{type} named '#{name}'" end

    protected
    def type; self.class.name.split('::').last.downcase end

    def naming_dictionary
      raise "Override Model#naming_dictionary in #{self.class.name.to_s}"
    end

    def name_elements(i)
      naming_dictionary.entries
    end

    # def self.child_type; raise "Override Model#child_type" end

    def self.root_node?; false end
    def self.leaf_node?; false end



    def self.generate_parent
      return if self.root_node?
      self.parent_type.new(children: [self])
    end

    def self.generate_children(parent,n=self.children_range.to_a.sample)
      return [] if self.leaf_node?
      Array.new(n) { self.child_type.new(parent: parent) }
    end

    def generate_name
      Name.generate(self, (1..3).to_a.sample)# # self.class.name_element_range.to_a.sample)
    end
  end
end
