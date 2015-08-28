require 'spec_helper'
require 'cosmic/name'
require 'pry'

describe Name do
  let(:components) { ['some', 'name'] }
  context "#new" do
    it 'should have the expected value' do
      name = Name.new(components)
      expect(name.to_s).to eql(components.map(&:capitalize).join(' '))
    end
  end

  context "#elements" do
    it 'should break down a name into components' do
      name = Name.new(*components)
      expect(name.elements).to eql(components)
    end
  end

  context ".generate" do
    it 'should create a name from elements' do
      model = double()
      expect(model).to receive(:name_elements).exactly(4).times.and_return(%w[ test some values ])
      generated = Name.generate(model)

      expected_elements = model.name_elements.map(&:capitalize)
      generated.to_s.split(' ').each do |element|
        expect(expected_elements).to include(element)
      end
    end
  end
end


