require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

if RUBY_VERSION >= '1.9'
  namespace :cover_me do
    desc "Generates and opens code coverage report."
    task :report do
      require 'cover_me'
      CoverMe.complete!
    end
  end
  task :spec do
    Rake::Task['cover_me:report'].invoke unless ENV['TRAVIS_RUBY_VERSION']
  end
else
  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.rcov = true
    spec.rcov_opts = ['-Ilib -Ispec --exclude spec,gems']
  end
end

task :default => :spec