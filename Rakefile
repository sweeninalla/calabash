require 'bundler/gem_tasks'
require File.join(File.dirname(__FILE__), 'build', 'build.rb')

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError => _
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |_|
    # See .yardopts for options.
  end
rescue LoadError => _
end

task :build => 'build:full_build' do
end

namespace :build do
  task :ensure_calabash_js_exists do
    Calabash::Build::AndroidTestServer.ensure_calabash_js_exists
  end

  task :full_build => [:ensure_calabash_js_exists] do
  end
end
