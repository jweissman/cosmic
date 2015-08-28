module Cosmic
  module Genealogical; end
  # class TreeVisitor
  #   def initialize(model)
  #     @model = model
  #   end

  #   def parent
  #     return nil if @model.class.root_node?

  #     @model.parent ||= generate_parent
  #   end

  #   def children
  #     return [] if @model.class.leaf_node?

  #     if @children.empty?
  #       @children = generate_children
  #     elsif @children.length < @model.class.children_range.begin
  #       @children = @children + generate_children
  #     end

  #     @children
  #   end

  #   def descendants(depth: 2)
  #     return Enumerator.new {} if @model.class.leaf_node? || depth <= 0

  #     descendants_enumerator = Enumerator.new do |y|
  #       children.each { |child| y << child }
  #       children.map do |child|
  #         child.descendants(depth: depth - 1).each { |c| y << c }
  #       end
  #     end

  #     return descendants_enumerator
  #   end

  #   def ancestors(depth: 2)
  #     if parent.nil? || depth <= 0
  #       []
  #     elsif @ancestors.has_key?(depth)
  #       @ancestors[depth]
  #     else
  #       @ancestors[depth] = ([parent] + parent.ancestors(depth: depth - 1)).flatten
  #     end
  #   end

  #   def siblings
  #     parent.nil? ? [] : parent.children - [@model] 
  #   end

  #   def root
  #     return nil if @model.class.root_node?
  #     ancestors(depth: 10).lazy.detect { |a| a.class.root_node? }
  #   end

  #   def leaves
  #     return [] if @model.class.leaf_node?
  #     descendants(depth: 10).lazy.select { |d| d.class.leaf_node? }
  #   end

  #   
  #   private 

  #   def generate_parent
  #     return if @model.class.root_node?
  #     @model.class.parent_type.new(children: [@model])
  #   end

  #   def generate_children(n=@model.class.children_range.to_a.sample)
  #     return [] if @model.class.leaf_node?
  #     Array.new(n) { @model.class.child_type.new(parent: @model) }
  #   end
  # end

  # module Genealogical
  #   extend Fowardable

  #   def_delegators :visitor, :parent, :children, :ancestors, :descendenants

  #   def visitor; @visitor ||= TreeVisitor.new(self) end

  #   def self.root_node?; false end
  #   def self.leaf_node?; false end

  #   def self.children_range; (3..10) end
  # end

end
