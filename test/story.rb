require 'io/console'
require 'bundler/setup'
require 'string_dot_gradient'

w = STDOUT.tty? ? STDOUT.winsize[1] - 4 : 40
i = -1

# Story from https://moralstories.top/read/the-cows-and-the-tiger
story = <<~'EOF'.gsub(?\n, ?\s)
	Four cows lived in a forest near a meadow. They were good friends and did
	everything together. They grazed together and stayed together, because of
	which no tigers or lions were able to kill them for food. But one day, the friends
	fought and each cow went to graze in a different direction. A tiger and a lion saw
	this and decided that it was the perfect opportunity to kill the cows. They hid in
	the bushes and surprised the cows and killed them all, one by one.
EOF

# Adding new lines to the story based on the terminal size
story_with_newline = story.chars.each { |x|
	i += 1

	# Check if the w-th character exceeds terminal size or not
	# If it exceeds the size, add a new line in the story
	if i > w || i > w - 6 && x == ?\s.freeze
		x.rstrip!
		x << ?\n.freeze
		i = 0
	end
}.join

story_with_newline.gradient('f55', '55f', '3eb', 'fa0', 'ff50a6', 'ff0', &method(:print))
puts

puts ?\n * 2, story_with_newline.gradient('f55', '55f', '3eb', 'fa0', 'ff50a6', 'ff0', bold: true)
puts ?\n * 2, story_with_newline.gradient('f55', '55f', '3eb', 'fa0', 'ff50a6', 'ff0', blink: true)
puts ?\n * 2, story_with_newline.gradient('f55', '55f', '3eb', 'fa0', 'ff50a6', 'ff0', bold: true, blink: true)

puts ?\n * 2, story_with_newline.gradient('f55', '55f', '3eb', 'fa0', 'ff50a6', 'ff0', bg: true)
puts ?\n * 2, story_with_newline.gradient('f55', '55f', '3eb', 'fa0', 'ff50a6', 'ff0', exclude_spaces: false, bg: false)
puts ?\n * 2, story_with_newline.gradient('f55', '55f', '3eb', 'fa0', 'ff50a6', 'ff0')
