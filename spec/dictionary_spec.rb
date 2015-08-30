require 'spec_helper'

describe Dictionary do
  its(:entries) { is_expected.not_to be_empty }

  context ".of" do
    let(:taxonomy) { :female_human_names }
    subject { Dictionary.of(taxonomy) }

    let(:expected_entries) do
      File.open("data/#{taxonomy}.txt").read.each_line.map(&:strip).to_a 
    end

    it 'should load entries from a word list file' do
      expect(subject.entries).to eql(expected_entries)
    end
  end

  describe "#new" do
    context 'without arguments' do
      it 'has a single token entry' do
        expect(subject.entries.length).to eq(1)
      end
    end
  end

  context "#merged_with" do
    # describe 'a simple case' do
    #   let(:merged) { subject.merged_with('world') }
    #   it 'adds entries' do
    #     expect(merged.entries.length).to eq(2)
    #   end
    # end

    describe 'a more realistic case' do
      let(:merged) { subject.merged_with(['world','all']) }
      its 'adds entries as expected' do
        expect(merged.entries.length).to eq(3)
      end
    end
  end
end
