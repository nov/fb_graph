require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

if RUBY_VERSION >= '1.9'
  require 'cover_me'
  CoverMe.config do |c|
    c.file_pattern = /(#{CoverMe.config.project.root}\/lib\/.+\.rb)/i
  end
else
  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.rcov = true
    spec.rcov_opts = ['-Ilib -Ispec --exclude spec,gems']
  end
end

task :default => :spec