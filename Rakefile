# encoding: utf-8

require 'rubygems'
require 'rake'

begin
  gem 'rubygems-tasks', '~> 0.2'
  require 'rubygems/tasks'

  Gem::Tasks.new
rescue LoadError => e
  warn e.message
  warn "Run `gem install rubygems-tasks` to install Gem::Tasks."
end

begin
  gem 'rdoc', '~> 4.2.0'
  require 'rdoc/task'

  RDoc::Task.new do |rdoc|
    rdoc.title = "cosmic"
  end
rescue LoadError => e
  warn e.message
  warn "Run `gem install rdoc` to install 'rdoc/task'."
end
task :doc => :rdoc

begin
  gem 'rspec', '~> 3.3.0'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new
rescue LoadError => e
  task :spec do
    abort "Please run `gem install rspec` to install RSpec."
  end
end

#task :test    => [:spec, 'schemes:test' ]
task :default => 'schemes:spec'

###

namespace :schemes do
  task :spec do
    for scheme in %i( future fantasy minimal )
      fail unless sh("SCHEME=#{scheme} bundle exec parallel_rspec spec")
    end
  end
end

namespace :data do
  task :measure do
    sh "ls data/**/*.txt | xargs wc -l | sort -r | tail -n 30"
  end
end
