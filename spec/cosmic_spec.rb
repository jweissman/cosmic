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

describe Supercluster do
  it_behaves_like 'a model'
  its('class.child_type') { is_expected.to be(Galaxy) }
end

describe Galaxy do
  it_behaves_like 'a model'
  its('class.child_type') { is_expected.to be(Sun) }
end

describe Sun do
  it_behaves_like 'a model'  
  its('class.child_type') { is_expected.to be(Planet) }
end

describe Planet do
  it_behaves_like 'a model'
  its('class.child_type') { is_expected.to be(Continent) }
end

describe Continent do
  it_behaves_like 'a model'
  its('class.child_type') { is_expected.to be(Region) }
end

describe Region do
  it_behaves_like 'a model'
  its('class.child_type') { is_expected.to be(Settlement) }
end

describe Settlement do
  it_behaves_like 'a model'
  its('class.child_type') { is_expected.to be(Neighborhood) }
end

describe Neighborhood do
  it_behaves_like 'a model'
  its('class.child_type') { is_expected.to be(Building) }
end

describe Building do
  # it_behaves_like 'a model'
  its('class.child_type') { is_expected.to be(Person) }

  context "#naming_dictionary" do
    let(:parent) { subject.parent = Neighborhood.new(children: [subject]) }
    it 'should inherit name elements from parents names' do
      parent.name.elements.each do |element|
        expect(subject.naming_dictionary.entries).to include(element)
      end
    end
  end
end

describe Person do
  it_behaves_like 'a model'
  its('class.leaf_node?') { is_expected.to be true }
  

  context "attributes" do
    it 'should have a gender' do
      expect([:male, :female, :other]).to include(subject.gender)
    end

    it 'should have a profession' do
      dictionary = Dictionary.of(:profession_names)
      expect(dictionary.entries).to include(subject.profession)
    end

    it 'should have a personality' do
      dictionary = Dictionary.of(:personal_qualities)
      expect(dictionary.entries).to include(subject.personality)
    end
  end
end
