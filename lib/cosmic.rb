require 'cosmic/version'
require 'cosmic/dictionary'

require 'cosmic/name'
require 'cosmic/printer'
require 'cosmic/tree'
require 'cosmic/model'

require 'cosmic/leaf'
require 'cosmic/root'
require 'cosmic/celestial_body'
require 'cosmic/terrestrial_entity'

module Cosmic
  class Universe < Model
    extend Root
    def self.child_type; Supercluster end
    def generate_name; Name.new('Ea') end
  end

  class Supercluster < Model
    include CelestialBody

    def self.child_type; Galaxy end
    def self.parent_type; Universe end
  end

  class Galaxy < Model
    include CelestialBody
    def self.child_type; Sun end
    def self.parent_type; Supercluster end
  end

  class Sun < Model
    include CelestialBody
    def self.child_type; Planet end
    def self.parent_type; Galaxy end
  end

  class Planet < Model
    include CelestialBody
    def self.child_type; Continent end
    def self.parent_type; Sun end
  end

  class Continent < Model
    include TerrestrialEntity
    def self.child_type; Region end
    def self.parent_type; Planet end
  end

  class Region < Model
    include TerrestrialEntity
    def self.child_type; Settlement end
    def self.parent_type; Continent end
  end

  class Settlement < Model
    include TerrestrialEntity
    def self.child_type; Neighborhood end
    def self.parent_type; Region end
  end

  class Neighborhood < Model
    include TerrestrialEntity
    def self.child_type; Building end
    def self.parent_type; Settlement end
  end

  class Block < Model
    include TerrestrialEntity
    def self.child_type; Lot end
    def self.parent_type; Neighborhood end
  end

  class Lot < Model
    include TerrestrialEntity
    def self.child_type; Building end
    def self.parent_type; Block end
  end

  class Building < Model
    def self.child_type; Person end
    def self.parent_type; Lot end

    def self.building_types
      %i( agricultural commercial residential educational government industrial military religious transport infrastructure )
    end

    def self.building_conditions
      %i( well-kept decrepit immaculate modern rustic cold classical minimalist luxurious huge impressive iconic concrete brick timber simple spacious inspiring traditional timeless stunning immense delicate austere calm )
    end

    def building_type
      @building_type ||= self.class.building_types.sample
    end

    def naming_dictionary
      Dictionary.of("#{building_type}_building_names").merged_with(ancestor_name_elements)
    end

    def ancestor_name_elements(depth=3)
      ancestors(depth: 4).map(&:name).map(&:elements).flatten
    end

    def inspect
      "#{name} (#{building_type} #{type})"
    end

    def building_condition
      @condition ||= self.class.building_conditions.sample
    end
  end

  class Person < Model
    extend Leaf

    def self.parent_type; Building end

    def name_elements(i)
      if i == 0
        forename_dictionary.entries
      else
        surname_dictionary.entries
      end
    end

    def forename_dictionary
      Dictionary.of("#{gender}_human_names")
    end

    def surname_dictionary
      Dictionary.of :human_surnames
    end

    def inspect
      "#{type} #{name} (#{personality} #{gender} #{profession})" 
    end

    def gender
      @gender ||= [:male, :female].sample 
    end
    
    def profession
      @profession ||= Dictionary.of(:profession_names).entries.sample 
    end

    def personality
      @personality ||= Dictionary.of(:personal_qualities).entries.sample #[:joyful, :quiet, :aggressive]
    end
  end
end
