module Cosmic
  class Model
    include Printable

    DEFAULT_DEPTH = 8
    MAX_SEARCH_DEPTH = 25

    def self.children_range; (2..3) end
    def self.name_element_range; (1..3) end

    attr_writer :parent, :children

    def initialize(parent: nil, children: nil, name: nil) 
      @name     = name
      @parent   = parent
      @children = children

      if Dictionary.exists?(subtype_dictionary_name)
        subtype_dictionary.each do |subtype_name|
          define_singleton_method "#{subtype_name.gsub(' ', '_')}?" do
            subtype_name == self.subtype
          end
        end
      end
    end

    def inspect
      if subtype
        "the #{subtype} #{self.type} '#{name}'" 
      else
        "the #{self.type} '#{name}'"
      end
    end

    def type; self.class.name.split('::').last.downcase end

    def subtype_dictionary_name; "#{type}_types" end
    def subtype_dictionary; 
      return [] unless Dictionary.exists? subtype_dictionary_name
      @subtype_dictionary ||= Dictionary.of(subtype_dictionary_name) 
    end

    # TODO predicates subtypes!
    # if Dictionary.exists?(subtype_dictionary_name) 
    #   binding.pry
    #   subtype_dictionary.each do |subtype_name|
    #     define_method "#{subtype_name.gsub(' ', '_')}?" do
    #       subtype_name == self.subtype
    #     end
    #   end
    # else
    #   puts "--- No dictionary #{subtype_dictionary_name} exists!"
    # end

    def subtype
      # subtype_dictionary_name = "#{self.class.type}_types"
      # return nil unless Dictionary.exists?(self.class.subtype_dictionary_name)

      @subtype ||= self.subtype_dictionary.sample
    end

    def age;  @age ||= 0 end
    def name; @name ||= self.generate_name end

    def parent
      @parent ||= self.class.root_node? ? nil : self.class.generate_parent(self)
    end

    def children
      @children ||= self.class.leaf_node? ? [] : self.class.generate_children(self)
      @children
    end

    def descendants(depth: DEFAULT_DEPTH)
      return Enumerator.new {} if self.class.leaf_node? || depth <= 0

      @descendants_enumerator ||= Enumerator.new do |yielder|
        children.each { |child| yielder << child }
        children.map do |child|
          child.descendants(depth: depth - 1).each { |c| yielder << c }
        end
      end
    end

    def ancestors(depth: DEFAULT_DEPTH)
      return [] if parent.nil? || depth <= 0
      @ancestors = {}
      @ancestors[depth] ||= ([parent] + parent.ancestors(depth: depth - 1)).flatten
    end

    def siblings
      return [] if self.class.root_node?
      parent.children - [self] 
    end

    def root
      return nil if self.class.root_node?
      ancestors(depth: MAX_SEARCH_DEPTH).detect do |ancestor| 
        ancestor.class.root_node? 
      end
    end

    def leaves
      return [] if self.class.leaf_node?
      descendants(depth: MAX_SEARCH_DEPTH).lazy.select { |d| d.class.leaf_node? }
    end

    def ancestor_name_elements(depth=DEFAULT_DEPTH)
      ancestors(depth: depth).map(&:name).map(&:elements).flatten.uniq
    end

    protected

    def generate_name
      Name.generate(self, self.class.name_element_range.to_a.sample)
    end

    def naming_dictionary
      raise "Override Model#naming_dictionary in #{self.class.name.to_s}"
    end

    def name_elements(i)
      naming_dictionary.entries
    end

    def self.root_node?; false end
    def self.leaf_node?; false end

    def self.generate_parent(child)
      return if self.root_node?
      generated_parent = self.parent_type.new(children: [child])
      generated_parent.children = generated_parent.children + generated_parent.class.generate_children(generated_parent)
      generated_parent
    end

    def self.generate_children(parent,n=self.children_range.to_a.sample)
      return [] if self.leaf_node?
      Array.new(n) do 
        self.child_type.new(parent: parent)
      end
    end
  end
end
