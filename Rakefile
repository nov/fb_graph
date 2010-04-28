require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'fb_graph'
    gem.summary = %Q{A Ruby wrapper for Facebook Graph API}
    gem.description = %Q{A Ruby wrapper for Facebook Graph API}
    gem.email = 'nov@matake.jp'
    gem.homepage = 'http://github.com/nov/fb_graph'
    gem.authors = ['nov matake']
    gem.add_dependency 'json'
    gem.add_dependency 'activesupport'
    gem.add_dependency 'rest-client'
    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'rcov'
    gem.add_development_dependency 'fakeweb'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler not available. Install it with: gem install jeweler'
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.fail_on_error = false
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end
Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ['--exclude spec,gems']
end
task :spec => :check_dependencies
task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.read('VERSION')
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'fb_graph #{version}'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
