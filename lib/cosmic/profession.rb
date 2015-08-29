module Cosmic
  class Profession
    attr_reader :name, :type

    def initialize(name, type)
      @name = name
      @type = type
    end

    def self.dictionary_for_type(job_type)
      Dictionary.of("#{job_type.gsub(' ', '_')}_profession_names")
    end

    def self.generate(type: Dictionary.of(:job_types).sample)
      profession_name = dictionary_for_type(type).sample
      Profession.new(profession_name, type)
    end

    def self.all
      all_job_names = []
      Dictionary.of(:job_types).each do |job_type|
        dictionary_for_type(job_type).each do |job_name|
          all_job_names << job_name
        end
      end
      all_job_names
    end
  end
end
