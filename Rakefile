require "rake"
require "rake/testtask"

$:.unshift File.expand_path("../lib", __FILE__)
require "state_university_salaries/version"

task :gem => :build
task :build do
  system "gem build --quiet state_university_salaries.gemspec"
end

task :install => :build do
  system "sudo gem install --quiet state_university_salaries-#{SUS::VERSION}.gem"
end

task :release => :build do
  system "git tag -a #{SUS::VERSION} -m 'Tagging #{SUS::VERSION}'"
  system "git push --tags"
  system "gem push state_university_salaries-#{SUS::VERSION}.gem"
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test