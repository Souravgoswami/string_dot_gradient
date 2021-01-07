require "bundler/setup"
require "string_dot_gradient"

words = IO.readlines(File.join(__dir__, 'words')).join.freeze

t = Time.now
puts words.gradient('f55', '55f', '#3eb', '#55f')
puts "Time: #{Time.now - t}"
