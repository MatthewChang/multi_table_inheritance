$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "multi_table_inheritance/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "multi_table_inheritance"
  s.version     = MultiTableInheritance::VERSION
  s.authors     = ["Matthew Chang"]
  s.email       = ["matthew@callnine.com"]
  s.homepage    = "https://www.callnine.com"
  s.summary     = "Enable deep multi table inheritance"
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.7"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end
