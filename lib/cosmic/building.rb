module Cosmic
  class Building < Model
    def naming_dictionary
      Dictionary.of("#{subtype}_building_names").merged_with(ancestor_name_elements)
    end

    protected

    def condition
      @condition ||= Dictionary.of(:building_conditions).sample
    end
  end
end
