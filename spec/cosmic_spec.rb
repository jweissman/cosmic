require 'spec_helper'

describe Cosmic do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end

  context 'has a valid model for' do
    Dictionary.of(:hierarchy_terms).each do |term|
      describe term.classify.constantize do
        it_behaves_like 'a model'
      end
    end
  end
end
