# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/lib/selenium_dsl/version')

Gem::Specification.new do |spec|
  spec.name          = "selenium_dsl"
  spec.summary       = %q{Simple way to build Selenium code as DSL.}
  spec.description   = %q{Simple way to build Selenium code as DSL}
  spec.email         = "alexander.shvets@gmail.com"
  spec.authors       = ["Alexander Shvets"]
  spec.homepage      = "http://github.com/shvets/selenium_dsl"

  spec.files         = `git ls-files`.split($\)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.version       = SeleniumDSL::VERSION

  spec.add_runtime_dependency "selenium-webdriver", [">= 0"]
  spec.add_runtime_dependency "selenium", [">= 0"]
  spec.add_development_dependency "gemspec_deps_gen", [">= 0"]
  spec.add_development_dependency "gemcutter", [">= 0"]
  
end

