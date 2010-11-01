# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dms/version"

Gem::Specification.new do |s|
  s.name        = "dms"
  s.version     = DMS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = "http://rubygems.org/gems/dms"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "dms"
  
  s.add_dependency("activeresource", "~> 2.3.5")
  
  s.add_development_dependency("bundler", ">= 1.0.0")

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end