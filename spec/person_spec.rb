require 'spec_helper'

describe Person do
  its('class.leaf_node?') { is_expected.to be true }

  let(:gender)      { subject.send :gender }
  let(:profession)  { subject.send :profession }
  let(:personality) { subject.send :personality }
  let(:aspects)     { subject.send :aspects }

  context "attributes" do
    it 'should have a gender' do
      expect([:male, :female, :other]).to include(gender)
    end

    it 'should have a profession' do
      jobs = Profession.all
      expect(jobs).to include(profession.name)
    end

    it 'should have a personality' do
      dictionary = Dictionary.of(:personal_qualities)
      expect(dictionary.entries).to include(personality)
    end

    it 'should have interests' do
      dictionary = Dictionary.of(:human_interests)
      aspects.each do |aspect|
        expect(dictionary.entries).to include(aspect)
      end
    end
  end

  context "attribute methods" do
    context "personal predicates" do
      it 'should indicate gender' do
        expect([true,false]).to include(subject.male?)
        expect([true,false]).to include(subject.female?)
      end

      describe "profession methods" do
        Profession.all.each do |profession_name|
          it "should indicate whether the person has profession '#{profession_name}'" do 
           has_profession= subject.send("#{profession_name.gsub(' ','_')}?")
           expect([true,false]).to include(has_profession) 
          end
        end
      end

      context "professioan type predicates" do
        Dictionary.of(:job_types).each do |job_type|
          describe "##{job_type}?" do
            it "should indicate profession type '#{job_type}'" do
              has_job_type = subject.send("#{job_type.gsub(' ','_')}?")
              expect([true, false]).to include(has_job_type)
            end
          end
        end
      end

      context "person quality predicates" do
        Dictionary.of(:personal_qualities).each do |quality|
          describe "##{quality}?" do
            it "should indicate whether person has the quality #{quality}" do
              has_quality = subject.send("#{quality.gsub(' ','_')}?")
              expect([true, false]).to include(has_quality)
            end
          end
        end
      end 

      context "personal interest predicates" do
        Dictionary.of(:human_interests).each do |interest|
          describe "##{interest}?" do
            it "should indicate whether person has interest #{interest}" do
              has_interest = subject.send("#{interest.gsub(' ','_')}?")
              expect([true, false]).to include(has_interest)
            end
          end
        end
      end
    end
  end

  context "instance methods" do
    describe "#inspect" do
      it 'should include gender' do
        expect(subject.inspect).to include(gender.to_s)
      end

      it 'should include profession' do
        expect(subject.inspect).to include(profession.name)
      end

      it 'should include personality' do
        expect(subject.inspect).to include(personality)
      end
    end
  end
end
