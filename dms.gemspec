# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dms/version"

Gem::Specification.new do |s|
  s.name        = "dms"
  s.version     = DMS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jose Fernandez"]
  s.email       = ["jfernandez@fourcubed.com"]
  s.homepage    = "http://rubygems.org/gems/dms"
  s.summary     = %q{Ruby Gem for the FourCubed Data Management System}
  s.description = %q{Ruby Gem for the FourCubed Data Management System.  Wrapper for the RESTful API}

  s.rubyforge_project = "dms"
  
  s.add_dependency("httparty", ">= 0.6.1")
  
  s.add_development_dependency("bundler", ">= 1.0.3")
  s.add_development_dependency("rspec", "1.3.1")
  s.add_development_dependency("webmock", "1.4.0")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end