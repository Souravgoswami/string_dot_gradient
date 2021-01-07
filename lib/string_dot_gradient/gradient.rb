class String
	##
	# = gradient(*arg_colours, bg: false)    # => string or nil
	#
	# Prettifies your string by adding gradient colours
	#
	# This method accept a lot of colours. For example:
	#
	# 1. puts "Hello".gradient('#f55', '#55f')
	# This will add #f55 (red) to #55f (blue) gradient colours to your texts.
	#
	# 2. puts "Hello\nWorld".gradient('#f55', '#55f')
	# This will add #f55 (red) to #55f (blue) gradient colours to your texts, spanning multiple lines.
	#
	# 3. puts "Hello\nWorld!\nColours\nare\nrotated here".gradient('f55','55f', '3eb' 'ff5')
	# This will add #ff5555 (red) to #5555ff (blue) gradient colours to the first line,
	# 5555ff to 33eebb colour to the 2nd line,
	# 33eebb to ffff55 to the third line
	# And then back to ffff55 to ff5555 to the fourth line,
	# And it will continue to rotate between these colours.
	#
	# To stop rotating, just don't give more than two arguments to this method.
	#
	# Passing blocks is also optional, and is handy for animating text. For example:
	#    "Hello\nWorld!\nColours\nare\nrotated here".gradient('f55','55f', '3eb' 'ff5', bg:true) { |x| print x ; sleep 0.05 }
	#
	# This will pass the values to the block itself, and will draw the colourful text slowly.
	# Passing block will return nil from the method because the values will be passed to the block variable instead.
	#
	# Adding the option bg will change the background colour, but will keep the foreground colour
	# defined in the terminal settings.
	def gradient(*arg_colours, bg: false)
		colours, line_length = [], -1
		temp = ''
		all_rgbs = arg_colours.flatten.map(&method(:hex_to_rgb))

		block_given = block_given?

		r, g, b = all_rgbs[0]
		r2, g2, b2 = all_rgbs[1]
		rotate = all_rgbs.length > 2

		init = bg ? 48 : 38

		each_line do |c|
			_r, _g, _b = r, g, b
			n = c.length

			r_meth = r == r2 ? :itself : r2 > r ? [:+, r2.fdiv(n)] : [:-, r.fdiv(n)]
			g_meth = g == g2 ? :itself : g2 > g ? [:+, g2.fdiv(n)] : [:-, g.fdiv(n)]
			b_meth = b == b2 ? :itself : b2 > b ? [:+, b2.fdiv(n)] : [:-, b.fdiv(n)]

			if line_length != n || rotate
				line_length = n
				colours.clear

				i = -1
				while (i += 1) < n
					_r = _r.send(*r_meth)
					_g = _g.send(*g_meth)
					_b = _b.send(*b_meth)

					colours << [
						(_r < 0 ? 0 : _r > 255 ? 255 : _r.to_i),
						(_g < 0 ? 0 : _g > 255 ? 255 : _g.to_i),
						_b < 0 ? 0 : _b > 255 ? 255 : _b.to_i
					]
				end
			end

			i = -1
			while (i += 1) < n
				if block_given
					yield "\e[#{init};2;#{colours[i][0]};#{colours[i][1]};#{colours[i][2]}m#{c[i]}"
				else
					temp.concat(
						"\e[#{init};2;#{colours[i][0]};#{colours[i][1]};#{colours[i][2]}m#{c[i]}"
					)
				end
			end

			if block_given
				yield "\e[0m".freeze
			else
				temp << "\e[0m".freeze
			end

			if rotate
				all_rgbs.rotate!
				r, g, b = all_rgbs[0]
				r2, g2, b2 = all_rgbs[1]
			end
		end

		block_given ? nil : temp
	end

	private
	def hex_to_rgb(hex)
		colour = +hex.dup.to_s
		colour.strip!
		colour.downcase!
		colour[0] = ''.freeze if colour.start_with?(?#.freeze)

		# out of range
		oor = colour.scan(/[^a-f0-9]/)

		unless oor.empty?
			invalids = colour.chars.map { |x|
				oor.include?(x) ? "\e[1;31m#{x}\e[0m" : x
			}.join

			puts "Hex Colour ##{invalids} is Out of Range"
			raise ArgumentError
		end

		if colour.length == 3
			colour.chars.map { |x| x.<<(x).to_i(16) }
		elsif colour.length == 6
			colour.chars.each_slice(2).map { |x| x.join.to_i(16) }
		else
			raise ArgumentError, "Invalid Hex Colour ##{colour}"
		end
	end
end
