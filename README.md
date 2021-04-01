# StringDotGradient [![Gem Version](https://badge.fury.io/rb/string_dot_gradient.svg)](https://rubygems.org/gems/string_dot_gradient) ![Test](https://github.com/souravgoswami/string_dot_gradient/workflows/StringDotGradient/badge.svg)

An itty-bitty extension that adds gradient method to String class that supports any hex colour, for Linux | Unix terminals only

![Preview](https://github.com/Souravgoswami/string_dot_gradient/blob/master/images/preview.jpg)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'string_dot_gradient'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install string_dot_gradient
```

## Usage

### With this gem installed, you can require 'string_dot_gradient' and run this on any string:

```
irb
irb(main):001:0> require 'string_dot_gradient'
=> true

irb(main):002:0> puts 'abcdefgh'.gradient('ff5', '55f')
abcdefgh
=> nil
```

This actually generates ANSI sequences to create gradient colours:

```
irb(main):003:0> 'abcdefgh'.gradient('ff5', '55f')
=> "\e[38;2;223;223;116ma\e[38;2;191;191;148mb\e[38;2;159;159;180mc\e[38;2;127;127;212md\e[38;2;95;95;244me\e[38;2;63;63;255mf\e[38;2;31;31;255mg\e[38;2;0;0;255mh\e[0m"
```

### You can also pass any arbitrary colours for multilined string, and get the colours rotate smoothly:

```
puts "Hello 🐵\nI am using string_dot_gradient!\nLove this gem!".gradient('f55', '55f', '3eb', 'f5f')
```

### Here's how the real method definition of gradient looks like:

```
def gradient(*arg_colours,
	exclude_spaces: true,
	bg: false,
	bold: false,
	blink: false,
	underline: false,
	double_underline: false,
	overline: false,
	italic: false,
	strikethrough: false
	)
```

Do note that the strikethrough, overline, double_underline may not work on every terminal.
The blink might not work on terminals that don't implement cursor blinking (integrated terminals in some IDE for example)

### Colours

The gradient can be any hex colour. Sample colours can be:

1. #f55
2. #ff5555
3. f55
4. ff5555

Any bad colour that's out of hex range, will raise ArgumentError.

### From version 0.3.0, there's also a method called `String#multi_gradient()`

```
'Hello world this is multi_gradient()'.multi_gradient('3eb', '55f', 'f55', 'fa0')
"Hello world\nthis is multi_gradient()".multi_gradient('3eb', '55f', 'f55', 'fa0')
```

You can pass N number of colours to multigradient, and prints that in one line.
multi_gradient() also accepts, bold, blink, underline, etc options that gradient() accepts.

Do note that multiline colours will not get rotated like String#gradient(), but will be applied to each line instead.

![Preview](https://github.com/Souravgoswami/string_dot_gradient/blob/master/images/multi_gradient.jpg)

### Passing Blocks
Sometimes it can be time-consuming for a very big string. Also, this could consume a lot of memory.
Just take a look at the return value of "abcdefgh" above, you know it has a lot of extra characters!

To prevent creating a new string, and yield whatever is getting processed, use a block.

You can use printf and whatnot in that block. For example:

```
$ irb
irb(main):001:0> require 'string_dot_gradient'
=> true

irb(main):002:0> "Hello\nWorld".gradient('#f55', '#55f') { |x| print x }
Hello
World=> nil

irb(main):003:0> "Hello\nWorld".gradient('#f55', '#55f') { }
=> nil

```

As you can see, it returns nil, but the value of the string is yielded to the block variable instead.
This makes it consume way lesser memory.

### Animation
You can animate your text using blocks!

Here's an example:

![Preview](https://github.com/Souravgoswami/string_dot_gradient/blob/master/images/preview.gif)

Code used:

```
require 'io/console'
require 'string_dot_gradient'

w = STDOUT.winsize[1] - 4
i = -1

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

	# Check if the w-th character exceeds the terminal size or not
	# If it exceeds the size, add a new line in the story

	if i > w || i > w - 6 && x == ?\s.freeze
		x.rstrip!
		x << ?\n.freeze
		i = 0
	end
}.join

story_with_newline.gradient('f55', '55f', '3eb', 'fa0', 'ff50a6', 'ff0') { |x|
	print x
	sleep 0.01
}

puts
```

[ Story from: https://moralstories.top/read/the-cows-and-the-tiger ]

You can also use multi_gradient() and pass blocks, to yield the characters
to the block instead.


## Excluding Spaces and tabs
A string can contain spaces or tabs, to exclude them, use the exclude_spaces optional.
Set it to true or false. A truthy or falsey value will also work, but it's not recommended.

+ if exclude_spaces is set to true, it will not waste colours on spaces and tabs
+ if exclude_spaces is set to false, it will waste colours on spaces and tabs

![Preview](https://github.com/Souravgoswami/string_dot_gradient/blob/master/images/exclude_spaces.jpg)

## Development

After checking out the repo, run `bin/setup` to install dependencies.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Souravgoswami/string_dot_gradient.

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
