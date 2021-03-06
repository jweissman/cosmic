require 'spec_helper'

def leaf_key; "#{hierarchy[hierarchy.length-1].pluralize}.first" end
def hierarchy; Dictionary.of(:hierarchy_terms).entries; end

def subtype_dictionary_name(klass); "#{klass.name.split('::').last.downcase}_types" end
def subtype_dictionary_exists?(klass); Dictionary.exists?(subtype_dictionary_name(klass)) end
def subtype_dictionary(klass); Dictionary.of(subtype_dictionary_name(klass)) end

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

      it "should have siblings of the expected type" do
        subject.siblings.each do |sibling|
          is_expected.to be_a(described_class) 
        end
      end

      its(:root)        { is_expected.not_to be_nil }
      let(:root_class)  { hierarchy.first.classify.constantize }
      its(:root)        { is_expected.to be_a(root_class) }
      its(hierarchy[0]) { is_expected.to be_a(root_class) }
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

      let(:leaf_class) { subject.leaves.first.class }
      its(leaf_key) { is_expected.to be_a(leaf_class) }

      unless described_class.child_type.leaf_node?
        let(:childrens_children) { subject.children.map(&:children).flatten }

        its(:descendants) { is_expected.to include(*childrens_children) }
        its('children.first.children') { is_expected.not_to(be_empty) }
      end
    end
  end

      
  context "instance methods" do
    context "subtype predicates" do
      if subtype_dictionary_exists?(described_class) 
        subtype_dictionary(described_class).each do |subtype_name|
          describe "should respond to predicate '#{subtype_name}'" do
            its(:"#{subtype_name.gsub(' ', '_')}?") { is_expected.to eql(subject.subtype == subtype_name) }
          end
        end
      end
    end

    describe "#narrate" do
      let(:narration) { subject.narrate }

      it 'should include the name' do
        expect(narration).to include(subject.name.to_s)
      end

      it 'should include the type' do
        expect(narration).to include(subject.type)
      end

      it 'should include the subtype' do
        expect(narration).to include(subject.subtype) if subject.subtype
      end

      unless described_class.leaf_node?
        it 'should describe children names' do
          subject.children.each do |child|
            expect(narration).to include(child.name.to_s)
          end
        end

        it 'should describe children types' do
          subject.children.each do |child|
            expect(narration).to include(child.type)
          end
        end
      end
    end
  end
end
