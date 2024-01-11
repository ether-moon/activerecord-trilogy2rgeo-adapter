# frozen_string_literal: true

require "./lib/active_record/connection_adapters/trilogis/version.rb"

Gem::Specification.new do |spec|
  spec.name = "activerecord-trilogis-adapter"
  spec.summary = "ActiveRecord adapter for MySQL, based on RGeo."
  spec.description =
    "ActiveRecord connection adapter for MySQL. It is based on the stock MySQL adapter, and adds " \
    "built-in support for the spatial extensions provided by MySQL. It uses the RGeo library to represent " \
    "spatial data in Ruby."

  spec.version = ActiveRecord::ConnectionAdapters::Trilogis::VERSION
  spec.author = "Ether Moon"
  spec.email = "ether.moon@kakao.com"
  spec.homepage = "http://github.com/ether-moon/activerecord-trilogis-adapter"
  spec.license = "BSD-3-Clause"

  spec.files = Dir["lib/**/*", "LICENSE.txt"]
  spec.platform = Gem::Platform::RUBY

  spec.required_ruby_version = ">= 2.7.0"

  spec.add_dependency "activerecord", "~> 7.0.0"
  spec.add_dependency "rgeo-activerecord", "~> 7.0.0"

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.4"
  spec.add_development_dependency "mocha", "~> 2.0"
  spec.add_development_dependency "appraisal", "~> 2.0"
end
