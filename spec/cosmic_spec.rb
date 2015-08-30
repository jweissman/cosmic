require 'spec_helper'

describe Cosmic do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end

  context 'should have valid models' do
    Dictionary.of(:hierarchy_terms).each do |term|
      describe term.classify.constantize do
        it_behaves_like 'a model'
      end
    end
  end
end

# describe Region do
#   it_behaves_like 'a model'
#   its('class.parent_type') { is_expected.to be(Continent) }
#   its('class.child_type') { is_expected.to be(Settlement) }
# end
# 
# describe Settlement do
#   it_behaves_like 'a model'
#   its('class.parent_type') { is_expected.to be(Region) }
#   its('class.child_type') { is_expected.to be(Neighborhood) }
# end
# 
# describe Neighborhood do
#   it_behaves_like 'a model'
#   its('class.parent_type') { is_expected.to be(Settlement) }
#   its('class.child_type') { is_expected.to be(Block) }
# end
# 
# describe Block do
#   it_behaves_like 'a model'
#   its('class.parent_type') { is_expected.to be(Neighborhood) }
#   its('class.child_type') { is_expected.to be(Lot) }
# end
# 
# describe Lot do
#   it_behaves_like 'a model'
#   its('class.parent_type') { is_expected.to be(Block) }
#   its('class.child_type') { is_expected.to be(Building) }
# end
