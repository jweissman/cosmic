module Cosmic
  class Building < Model
    # def self.parent_type; Lot end
    # def self.child_type; Person end

    def naming_dictionary
      Dictionary.of("#{building_type}_building_names").merged_with(ancestor_name_elements)
    end

    def inspect
      "#{name} (#{building_type} #{type})"
    end

    protected

    def building_type
      @building_type ||= Dictionary.of(:building_types).sample
    end

    def condition
      @condition ||= Dictionary.of(:building_conditions).sample
    end
  end
end
