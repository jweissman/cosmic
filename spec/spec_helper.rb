gem 'rspec', '~> 3.3.0'
gem 'rspec-its', '~> 1.2.0'

require 'rspec'
require 'rspec/its'
require 'cosmic'

include Cosmic

require 'examples/a_model_spec'

require 'pry'
require 'ruby-prof'

if ENV["PROFILE"]
  RSpec.configure do |config|
    config.before(:suite) do
      RubyProf.start
    end
  
    config.after(:suite) do
      result = RubyProf.stop
      printer = RubyProf::FlatPrinter.new(result)
      printer.print(STDOUT)
    end
  end
end
