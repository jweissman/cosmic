require 'spec_helper'

describe Dictionary do
  its(:entries) { is_expected.not_to be_empty }

  context ".of" do
    let(:taxonomy) { :female_human_names }
    let(:scheme) { :minimal }
    subject { Dictionary.of(taxonomy, scheme) }

    let(:expected_entries) do
      File.open("data/#{scheme}/#{taxonomy}.txt").read.each_line.map(&:strip).to_a 
    end

    it 'should load entries from a word list file' do
      expect(subject.entries).to eql(expected_entries)
    end
  end

  context ".exists?" do
    let(:existing_taxonomy) { :building_types }
    let(:inexistent_taxonomy) { :unicorn_horn_types }

    it 'should indicate existing taxonomies' do
      exists = Dictionary.exists?(existing_taxonomy)
      expect(exists).to be true
    end

    it 'should indicate non-existing taxonomies' do
      exists = Dictionary.exists?(inexistent_taxonomy)
      expect(exists).to be false
    end 
  end


  context "#new" do
    describe 'without arguments' do
      it 'has a single token entry' do
        expect(subject.entries.length).to eq(1)
      end
    end
  end

  context "#merged_with" do
    describe 'a more realistic case' do
      let(:merged) { subject.merged_with(['world','all']) }
      its 'adds entries as expected' do
        expect(merged.entries.length).to eq(3)
      end
    end
  end
end
