module Cosmic
  def self.bootstrap(hierarchy)
    hierarchy.each_with_index do |level_term, level_index|
      entity = if level_index >= ((hierarchy.length-6)/2).round
                 "include TerrestrialEntity"
               else
                 "include CelestialBody"
               end

      child_type = if level_index < hierarchy.length-1
                     "def self.child_type; #{hierarchy[level_index+1].classify} end"
                   end

      parent_type = if level_index > 0
                      "def self.parent_type; #{hierarchy[level_index-1].classify} end"
                    end

      level_ruby = <<-rb
        class #{level_term.classify} < Model                        #  class Universe < Model
          #{'extend Root' if level_index.zero? }                    #    extend Root
          #{'extend Leaf' if level_index == hierarchy.length-1}     #    
          #{entity}                                                 #    include CelestialBody
          #{parent_type}                                            #    
          #{child_type}                                             #    def self.child_type; [Sector] end
        end; #{level_term.classify}                                 #  end; Universe
      rb

      eval level_ruby
    end
  end
end
