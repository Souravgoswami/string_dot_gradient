require "bundler/setup"
require "string_dot_gradient"

words = IO.readlines(File.join(__dir__, 'words')).join.freeze

t = Time.now
puts words.gradient('55f', '#3eb', '#55f', 'FEC40E', 'E93884')
puts "Time: #{Time.now - t}"
