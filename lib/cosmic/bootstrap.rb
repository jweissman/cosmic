require 'pry'
module Cosmic
  class BootstrapCode
    attr_reader :hierarchy

    def initialize(hierarchy)
      @hierarchy = hierarchy
    end

    def generate!
      @hierarchy.each_with_index(&method(:apply_model_code))
    end

    def apply_model_code(model,index)
      ruby_code = generate_model_code(model,index)

      puts 
      puts "===== RUBY CODE FOR #{model} ====="
      puts ruby_code
      puts "------ END RUBY CODE FOR #{model} ----"

      Cosmic.module_eval ruby_code
    end

    def generate_entity_code(index)
      entity_cutoff = ((hierarchy.length-6)/2).round

      if index >= entity_cutoff
        "include TerrestrialEntity"
      else
        "include CelestialBody"
      end
    end

    def generate_child_type_code(index)
      if index < hierarchy.length-1
        "def self.child_type; #{hierarchy[index+1].classify} end"
      end
    end

    def generate_parent_type_code(index)
      if index > 0
        "def self.parent_type; #{hierarchy[index-1].classify} end"
      end
    end

    def generate_ancestor_types_code(index)
      if index > 0
        rb = ""
        hierarchy[0...index].each_with_index do |ancestor_term, ancestor_index|
          depth = index - ancestor_index
          rb += "def #{ancestor_term}; (ancestors(depth: #{depth}) - ancestors(depth: #{depth-1})).first end\n"
        end
        rb
      end
    end

    def generate_descendant_types_code(index)
      hierarchy_indices = Hash[hierarchy.map.with_index.to_a]
      if index < hierarchy.length-1
        rb = "\n"
        hierarchy[(index+1)...(hierarchy.length)].each_with_index do |descendant_term, descendant_index|
          depth = hierarchy_indices[descendant_term] - index
          rb += "  def #{descendant_term.pluralize}             \n"
          rb += "    descendants(depth: #{depth}).lazy.select do |d| \n" 
          rb += "      d.is_a?(#{descendant_term.classify})     \n"
          rb += "    end                                        \n"
          rb += "  end                                          \n"
        end
        rb
      end
    end

    def generate_model_code(model,index)
      entity = generate_entity_code index
      child_type  = generate_child_type_code index
      parent_type = generate_parent_type_code index
      ancestor_types = generate_ancestor_types_code index 
      descendant_types = generate_descendant_types_code index

      ruby = <<-END_RUBY
        class #{model.classify} < Model                             
          #{'extend Root' if index.zero? }                          
          #{'extend Leaf' if index == hierarchy.length-1}           
          #{entity}                                                 
          #{parent_type}                                            
          #{child_type}                                             

          #{ancestor_types}                                         
                                                                    

          #{descendant_types}                                       
                                                                    

        end # #{model.classify}                                      
      END_RUBY

      # e.g.:
      #  class Galaxy < Model
      #    extend Root
      #    
      #    include CelestialBody                                                    
      #    
      #    def self.child_type; [Sector] end
                                                                               
      #    def universe; (ancestors(depth: 5) - ancestors(depth: 4)).first end
      #    ...
                                                                               
      #    def people; [see above] end
      #    ...
                                                                               
      #  end; Galaxy
      
      ruby
    end
  end

  def self.bootstrap(hierarchy=Dictionary.of(:hierarchy_terms).entries)
    BootstrapCode.new(hierarchy).generate!
  end
end
