require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'fb_graph'
    gem.summary = %Q{A full-stack Facebook Graph API wrapper in Ruby.}
    gem.description = %Q{A full-stack Facebook Graph API wrapper in Ruby.}
    gem.email = 'nov@matake.jp'
    gem.homepage = 'http://github.com/nov/fb_graph'
    gem.authors = ['nov matake']
    gem.add_dependency 'json', '>= 1.4.3'
    gem.add_dependency 'activesupport', '>= 2.3'
    gem.add_dependency 'httpclient', '>= 2.1.6'
    gem.add_dependency 'oauth2', '>= 0.1.0'
    gem.add_development_dependency 'rspec', '~> 1.3'
    gem.add_development_dependency 'rcov'
    gem.add_development_dependency 'fakeweb', '>= 1.3.0'
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
