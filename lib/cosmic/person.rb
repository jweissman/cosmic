module Cosmic
  class Person < Model
    #jextend Leaf

    #def self.parent_type; Building end
    def self.name_element_range; (2..4) end

    def inspect
      base = "#{type} #{name} (#{personality} #{gender} #{profession.name})" 
      aspects.each do |aspect|
        base += " [#{aspect}]"
      end
      base
    end
    
    GENDERS = [ :male, :female ]
    GENDERS.each do |gender_option|
      define_method "#{gender_option}?" do
        gender == gender_option
      end
    end

    Profession.all.each do |profession_name|
      define_method "#{profession_name.gsub(' ','_')}?" do
        profession.name == profession_name
      end
    end

    Dictionary.of(:job_types).each do |profession_type|
      define_method "#{profession_type.gsub(' ','_')}?" do
        profession.type == profession_type
      end
    end

    Dictionary.of(:personal_qualities).each do |personal_quality|
      define_method "#{personal_quality}?" do
        personality == personal_quality
      end
    end

    Dictionary.of(:human_interests).each do |interest|
      define_method "#{interest.gsub(' ', '_')}?" do
        aspects.include?(interest)
      end
    end

    protected

    def name_elements(i)
      if i == 0
        forename_dictionary.entries
      else
        surname_dictionary.entries
      end
    end


    def gender
      @gender ||= [:male, :female].sample 
    end
    
    def profession
      @profession ||= Profession.generate # Dictionary.of(:profession_names).sample 
    end

    def personality
      @personality ||= Dictionary.of(:personal_qualities).sample
    end

    def aspects
      @aspects ||= Dictionary.of(:human_interests).sample( (0..5).to_a.sample )
    end

    private

    def forename_dictionary
      Dictionary.of("#{gender}_human_names")
    end

    def surname_dictionary
      Dictionary.of :human_surnames
    end
  end
end
