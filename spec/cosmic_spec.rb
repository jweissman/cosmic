require 'spec_helper'

describe Cosmic do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end
end

describe Universe do
  it_behaves_like 'a model'
  its('class.root_node?') { is_expected.to be true }
  its('class.child_type') { is_expected.to be(Sector) }
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
  its('class.child_type') { is_expected.to be(Block) }
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
