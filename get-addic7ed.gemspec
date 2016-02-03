# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'addic7ed/version'

Gem::Specification.new do |spec|
  spec.name          = "get-addic7ed"
  spec.version       = GetAddic7ed::VERSION
  spec.date          = '2016-01-27'
  spec.authors       = ["Nicolas Vergoz"]
  spec.email         = ["nicolas.vergoz@gmail.com"]

  spec.summary       = "Get subtitles from Addic7ed"
  spec.description   = "Ruby tool to download subtitles from Addic7d based on video file name"
  spec.homepage      = "http://rubygems.org/gems/get-addic7ed"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

=begin
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
=end

  spec.files       = Dir["lib/*", "lib/**/*"]
  spec.executables   = ["get-addic7ed"]
  spec.require_paths = ["lib"]
  spec.has_rdoc    = false

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"


  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
  spec.add_runtime_dependency 'fuzzy-string-match', '~> 0'
end
