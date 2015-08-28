module Cosmic
  module CelestialBody
    def naming_dictionary
      Dictionary.of(:celestial_names).merged_with ancestor_name_elements
    end
  end
end
