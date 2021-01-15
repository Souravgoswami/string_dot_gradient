# frozen_string_literal: true
require_relative "lib/string_dot_gradient/version"

Gem::Specification.new do |s|
	s.name = "string_dot_gradient"
	s.version = StringDotGradient::VERSION
	s.authors = ["Sourav Goswami"]
	s.email = ["souravgoswami@protonmail.com"]
	s.summary = %(An itty-bitty extension that adds "gradient" method to String class that supports any hex colour, for Linux terminals)
	s.description = s.summary
	s.homepage = "https://github.com/Souravgoswami/string_dot_gradient"
	s.license = "MIT"
	s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
	s.files = Dir.glob(%w(lib/**/*.rb))
	s.require_paths = ["lib"]
end
