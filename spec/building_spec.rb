require 'spec_helper'

describe Building do
  let(:condition) { subject.send :condition }

  context "attributes" do
    if Dictionary.exists?(:building_conditions)
      it 'has a condition' do
        dictionary = Dictionary.of(:building_conditions)
        expect(dictionary.entries).to include(condition)
      end
    end

    it 'has a building type' do
      dictionary = Dictionary.of(:building_types)
      expect(dictionary.entries).to include(subject.subtype)
    end
  end

  context "instance methods" do
    describe "#naming_dictionary" do
      let(:parent) { subject.parent = subject.class.parent_type.new(children: [subject]) }
      it 'should inherit name elements from parents names' do
        parent.name.elements.each do |element|
          expect(subject.naming_dictionary.entries).to include(element)
        end
      end
    end
  end
end

