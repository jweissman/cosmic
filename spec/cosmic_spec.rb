require 'spec_helper'
require 'cosmic'
require 'pry'

describe Cosmic do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end
end

describe Universe do
  it_behaves_like 'a model'
  its('class.root_node?') { is_expected.to be true }
  its('class.child_type') { is_expected.to be(Supercluster) }
end

describe Sector do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Universe) }
  its('class.child_type') { is_expected.to be(Supercluster) }
end

describe Supercluster do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Sector) }
  its('class.child_type') { is_expected.to be(Galaxy) }
end

describe Galaxy do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Supercluster) }
  its('class.child_type') { is_expected.to be(Sun) }
end

describe Sun do
  it_behaves_like 'a model'  
  its('class.parent_type') { is_expected.to be(Galaxy) }
  its('class.child_type') { is_expected.to be(Planet) }
end

describe Planet do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Sun) }
  its('class.child_type') { is_expected.to be(Continent) }
end

describe Continent do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Planet) }
  its('class.child_type') { is_expected.to be(Region) }
end

describe Region do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Continent) }
  its('class.child_type') { is_expected.to be(Settlement) }
end

describe Settlement do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Region) }
  its('class.child_type') { is_expected.to be(Neighborhood) }
end

describe Neighborhood do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Settlement) }
  its('class.child_type') { is_expected.to be(Building) }
end

describe Block do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Neighborhood) }
  its('class.child_type') { is_expected.to be(Lot) }
end

describe Lot do
  it_behaves_like 'a model'
  its('class.parent_type') { is_expected.to be(Block) }
  its('class.child_type') { is_expected.to be(Building) }
end

describe Building do
  it_behaves_like 'a model'

  its('class.parent_type') { is_expected.to be(Lot) }
  its('class.child_type') { is_expected.to be(Person) }
  
  let(:condition) { subject.send :condition }

  context "attributes" do
    it 'has a condition' do
      dictionary = Dictionary.of(:building_conditions)
      expect(dictionary.entries).to include(condition)
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

describe Person do
  it_behaves_like 'a model'

  its('class.leaf_node?') { is_expected.to be true }

  let(:gender) { subject.send :gender }
  let(:profession) { subject.send :profession }
  let(:personality) { subject.send :personality }


  context "attributes" do
    it 'should have a gender' do
      expect([:male, :female, :other]).to include(gender)
    end

    it 'should have a profession' do
      dictionary = Dictionary.of(:profession_names)
      expect(dictionary.entries).to include(profession)
    end

    it 'should have a personality' do
      dictionary = Dictionary.of(:personal_qualities)
      expect(dictionary.entries).to include(personality)
    end
  end

  context "instance methods" do
    describe "#inspect" do
      it 'should include gender' do
        expect(subject.inspect).to include(gender.to_s)
      end

      it 'should include profession' do
        expect(subject.inspect).to include(profession)
      end

      it 'should include personality' do
        expect(subject.inspect).to include(personality)
      end
    end
  end
end
