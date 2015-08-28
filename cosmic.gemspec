# -*- encoding: utf-8 -*-

require File.expand_path('../lib/cosmic/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "cosmic"
  gem.version       = Cosmic::VERSION
  gem.summary       = %q{TODO: Summary}
  gem.description   = %q{TODO: Description}
  gem.license       = "MIT"
  gem.authors       = ["Joseph Weissman"]
  gem.email         = "joseph.weissman@listen360.com"
  gem.homepage      = "https://rubygems.org/gems/cosmic"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake', '~> 10.4.2'
  gem.add_development_dependency 'rdoc', '~> 4.2.0'
  gem.add_development_dependency 'rspec', '~> 3.3.0'
  gem.add_development_dependency 'rspec-its', '~> 1.2.0'
  gem.add_development_dependency 'parallel_tests'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'pry', '~> 0.10.1'
  gem.add_development_dependency 'ruby-prof', '~> 0.15.2'

  gem.add_dependency 'nil_or', '~> 2.0.0'
end
