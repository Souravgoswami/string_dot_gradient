# StringDotGradient
An itty-bitty extension to add gradient method to Strings on Linux terminals. But it can break in TTYs.

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

With this gem installed, you can require 'string_dot_gradient' and run this on any string:

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

The gradient can be anything, but it has to be a hex colour. Sample colours can be:

#### Colours

1. #f55
2. #ff5555
3. f55
4. #ff5555

Any bad colour that's out of hex range, will raise ArgumentError.

#### Passing Blocks
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

## Development

After checking out the repo, run `bin/setup` to install dependencies.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Souravgoswami/string_dot_gradient.

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
