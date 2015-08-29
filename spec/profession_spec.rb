require 'spec_helper'

describe Profession do
  context "generating professions in the field of..." do
    Dictionary.of(:job_types).each do |type|
      context "#{type}" do
        subject { Profession.generate(type: type) }

        it 'should have a type' do
          dictionary = Dictionary.of(:job_types)
          expect(dictionary.entries).to include(subject.type)
        end

        it 'should have a name' do
          dictionary = Dictionary.of("#{subject.type.gsub(' ','_')}_profession_names")
          expect(dictionary.entries).to include(subject.name)
        end
      end
    end
  end
end
