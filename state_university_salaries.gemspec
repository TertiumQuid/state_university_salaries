$:.unshift File.expand_path("../lib", __FILE__)
require "state_university_salaries/version"

Gem::Specification.new do |gem|
  gem.name    = "state_university_salaries"
  gem.version = LDA::VERSION

  gem.author      = ["Travis Dunn", "Farhood Basiri", "John Long"]
  gem.email       = ["info@bellwethersystems.com"]
  gem.homepage    = "http://www.bellwethersystems.com/"
  gem.summary     = "CLI to scrape salary data."
  gem.description = "CLI tool for scraping florida state universities data."
  gem.license     = "Proprietary"
  gem.post_install_message = <<-MESSAGE
 !    The `State University Salaries` gem gathers data from government websites and dumps the output 
 !    Use from the command line:
 !        sus -output ~/sus
  MESSAGE

  gem.files       = `git ls-files`.split("\n").select { |d| d =~ %r{^(License|README|bin/|data/|ext/|lib/|spec/|test/)} }
  gem.executables = "lda"
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.add_dependency "thor"
  gem.add_dependency "sqlite3"
  gem.add_dependency "spreadsheet"
  gem.add_dependency "activerecord"
end