require 'spec_helper'

describe Building do
  its('class.parent_type') { is_expected.to be(Lot) }
  its('class.child_type') { is_expected.to be(Room) }
  
  let(:condition) { subject.send :condition }
  let(:building_type) { subject.send :building_type }

  context "attributes" do
    it 'has a condition' do
      dictionary = Dictionary.of(:building_conditions)
      expect(dictionary.entries).to include(condition)
    end

    it 'has a building type' do
      dictionary = Dictionary.of(:building_types)
      expect(dictionary.entries).to include(building_type)
    end
  end

  context "instance methods" do
    describe "#naming_dictionary" do
      let(:parent) { subject.parent = Neighborhood.new(children: [subject]) }
      it 'should inherit name elements from parents names' do
        parent.name.elements.each do |element|
          expect(subject.naming_dictionary.entries).to include(element)
        end
      end
    end
  end
end

