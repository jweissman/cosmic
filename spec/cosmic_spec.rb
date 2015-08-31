require 'spec_helper'

describe Cosmic do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end

  Dictionary.of(:hierarchy_terms).each do |term|
    describe term.classify.constantize do
      it { is_expected.to be_a Model }
      it_behaves_like 'a model'
    end
  end

  context 'user journey' do
    let(:city)   { City.new }
    let(:people) { city.people }

    let(:star_captains) { people.select(&:starship_captain?) }
    let(:bureaucrats) { people.select(&:government?).reject(&:warmhearted?) }

    it 'should filter/reject' do
      expect(star_captains.take(1)).not_to be_nil
      expect(bureaucrats.take(1)).not_to be_nil
    end
  end
end
