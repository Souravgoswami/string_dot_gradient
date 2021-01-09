# frozen_string_literal: true
require "bundler/gem_tasks"
require 'bundler/setup'
require 'string_dot_gradient'

task :default do
	puts "String Dot Gradient #{StringDotGradient::VERSION}".gradient '#3eb', '55f'
end

task :test do
	ruby 'test/test.rb'
	ruby 'test/story.rb'
end

task :story do
	ruby 'test/story.rb'
end
