require 'spec_helper'

shared_examples "a model" do
  context "class attributes" do
    describe ".leaf_node?" do
      it 'should be truthy/falsy' do
        expect([true,false]).to include(described_class.leaf_node?)
      end
    end

    describe ".root_node?" do
      it 'should be truthy/falsy' do
        expect([true,false]).to include(described_class.root_node?)
      end
    end

    unless described_class.leaf_node?
      describe '.child_type' do
        it 'should be a Class' do
          expect(described_class.child_type).to be_a(Class)
        end
      end
    end

    unless described_class.root_node?
      describe '.parent_type' do
        it 'should be a Class' do
          expect(described_class.parent_type).to be_a(Class)
        end
      end
    end
  end

  context "instance attributes" do
    its(:age)        { is_expected.to be_zero }

    describe "#name" do
      let(:expected_name) { 'the expected name' }

      before do
        expect_any_instance_of(Name).to receive(:to_s).and_return(expected_name)
      end

      its('name.to_s') { is_expected.to eql expected_name  }
    end

    its(:siblings)    { is_expected.to be_an Array }
    its(:children)    { is_expected.to be_an Array }

    its(:ancestors)   { is_expected.to be_an Array }
    its(:descendants) { is_expected.to be_an Enumerator }

    unless described_class.root_node?
      let(:parents_children) { subject.parent.children - [subject] }

      its('ancestors.first') { is_expected.to be_a(described_class.parent_type) }

      its(:siblings) { is_expected.not_to be_empty }
      its(:siblings) { is_expected.to eql(parents_children) }  
      its('siblings.first')  { is_expected.to be_a(described_class) }

      its(:root) { is_expected.not_to be_nil }
      its(:root) { is_expected.to be_a(Universe) }
    end

    unless described_class.leaf_node?
      its(:children)               { is_expected.not_to be_empty }
      its('children.first')        { is_expected.to be_a(described_class.child_type) }
      its('children.first.parent') { is_expected.to eq(subject) } 

      its(:descendants)   { is_expected.to be_any }
      its('descendants.first') { is_expected.to be_a(described_class.child_type) }
      its(:descendants)   { is_expected.to include(*subject.children) }

      its(:leaves)        { is_expected.to be_an Enumerator::Lazy }
      its('leaves.first') { is_expected.to be_a Person }

      unless described_class.child_type.leaf_node?
        let(:childrens_children) { subject.children.map(&:children).flatten }

        its(:descendants) { is_expected.to include(*childrens_children) }
        its('children.first.children') { is_expected.not_to(be_empty) }
      end
    end
  end

  context "instance methods" do
    describe "#narrate" do
      let(:narration) { subject.narrate }

      it 'should include the name' do
        expect(narration).to include(subject.name.to_s)
      end

      it 'should include the type' do
        expect(narration).to include(subject.send :type)
      end

      unless described_class.leaf_node?
        it 'should describe children names' do
          subject.children.each do |child|
            expect(narration).to include(child.name.to_s)
          end
        end

        it 'should describe children types' do
          subject.children.each do |child|
            expect(narration).to include(child.send :type)
          end
        end
      end
    end
  end
end
