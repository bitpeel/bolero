$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bolero/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bolero"
  s.version     = Bolero::VERSION
  s.authors     = ["Matt Goatcher"]
  s.email       = ["matt@bitpeel.com"]
  s.homepage    = "http://github.com/bitpeel/bolero"
  s.summary     = "Coming soon"
  s.description = "Coming soon"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README"]

  s.add_dependency "rails", '~> 5.0', '>= 4.2'

  s.add_development_dependency "rspec", "~> 3.0"
end
