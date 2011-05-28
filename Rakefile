require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
  spec.rcov_opts = ['-Ilib -Ispec --exclude spec,gems']
end

task :default => :spec