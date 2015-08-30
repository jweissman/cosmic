require 'spec_helper'

describe Person do
  it_behaves_like 'a model'

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
    it 'should indicate gender' do
      expect([true,false]).to include(subject.male?)
      expect([true,false]).to include(subject.female?)
    end

    it 'should indicate profession' do
      expect([true, false]).to include(subject.philosopher?)
      expect([true, false]).to include(subject.scientist?)
      expect([true, false]).to include(subject.airline_steward?)
    end

    it 'should indicate profession type' do
      expect([true, false]).to include(subject.technology?)
      expect([true, false]).to include(subject.transport?)
      expect([true, false]).to include(subject.government?)
    end

    it 'should indicate personal qualities' do
      expect([true, false]).to include(subject.warmhearted?)
      expect([true, false]).to include(subject.forceful?)
    end

    it 'should indicate interests' do
      expect([true, false]).to include(subject.wrestler?)
      expect([true, false]).to include(subject.pigeon_racer?)
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
