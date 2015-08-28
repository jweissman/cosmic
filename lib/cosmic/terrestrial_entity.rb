module Cosmic
  module TerrestrialEntity
    def naming_dictionary
      Dictionary.of(:terrestrial_names).merged_with ancestor_name_elements
    end
  end
end
