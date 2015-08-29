require 'active_support/inflector'

require 'cosmic/version'
require 'cosmic/dictionary'

require 'cosmic/name'
require 'cosmic/printer'
require 'cosmic/model'

require 'cosmic/leaf'
require 'cosmic/root'
require 'cosmic/celestial_body'
require 'cosmic/terrestrial_entity'

require 'cosmic/building'
require 'cosmic/profession'
require 'cosmic/person'

module Cosmic
  class Universe < Model
    extend Root
    def generate_name; Name.new('Ea') end
    def self.child_type; Sector end
  end

  class Sector < Model
    include CelestialBody
    def self.parent_type; Universe end
    def self.child_type; Supercluster end
  end

  class Supercluster < Model
    include CelestialBody

    def self.parent_type; Sector end
    def self.child_type;  Galaxy end
  end

  class Galaxy < Model
    include CelestialBody
    def self.parent_type; Supercluster end
    def self.child_type;  Sun end
  end

  class Sun < Model
    include CelestialBody
    def self.parent_type; Galaxy end
    def self.child_type;  Planet end
  end

  class Planet < Model
    include CelestialBody
    def self.parent_type; Sun end
    def self.child_type;  Continent end
  end

  class Continent < Model
    include TerrestrialEntity
    def self.parent_type; Planet end
    def self.child_type;  Region end
  end

  class Region < Model
    include TerrestrialEntity
    def self.parent_type; Continent end
    def self.child_type;  Settlement end
  end

  class Settlement < Model
    include TerrestrialEntity
    def self.parent_type; Region end
    def self.child_type;  Neighborhood end
  end

  class Neighborhood < Model
    include TerrestrialEntity
    def self.parent_type; Settlement end
    def self.child_type;  Block end
  end

  class Block < Model
    include TerrestrialEntity
    def self.parent_type; Neighborhood end
    def self.child_type;  Lot end
  end

  class Lot < Model
    include TerrestrialEntity
    def self.parent_type; Block end
    def self.child_type;  Building end
  end
end

