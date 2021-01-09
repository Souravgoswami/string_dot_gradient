class String
	##
	# = gradient(*arg_colours, bg: false, exclude_spaces: true)    # => string or nil
	#
	# Prettifies your string by adding gradient colours.
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
	#
	# The option exclude_spaces, is expected to set either true or false.
	# By default it's set to true.
	# Enabling this option will not waste colours on white-spaces.
	# White spaces only include: \s, \t
	#
	# Please do note that \u0000 and \r in the middle of the string will not be
	# counted as a white space, but as a character instead.
	# This is because \r wipes out the previous characters, and using \u0000 in
	# a string is uncommon, and developers are requested to delete
	# \u0000 from string if such situations arise.
	def gradient(*arg_colours, bg: false, exclude_spaces: true)
		colours, line_length = [], -1
		temp = ''
		flatten_colours = arg_colours.flatten

		raise ArgumentError, "Wrong numeber of colours (given #{flatten_colours.length}, expected minimum 2)" if flatten_colours.length < 2
		raise ArgumentError, "Given argument for colour is neither a String nor an Integer" if flatten_colours.any? { |x| !(x.is_a?(String) || x.is_a?(Integer)) }

		all_rgbs = flatten_colours.map!(&method(:hex_to_rgb))
		block_given = block_given?

		r, g, b = all_rgbs[0]
		r2, g2, b2 = all_rgbs[1]
		rotate = all_rgbs.length > 2

		init = bg ? 48 : 38

		each_line do |c|
			_r, _g, _b = r, g, b
			n = c.length

			r_op = r_val = r_max = r_min = nil
			g_op = g_val = g_max = g_min = nil
			b_op = b_val = b_max = b_min = nil

			r_comp_op = r_comp_val = nil
			g_comp_op = g_comp_val = nil
			b_comp_op = b_comp_val = nil

			if r2 > r
				r_op, r_val, r_max, r_min = :+, r2.fdiv(n), r2, r
				r_comp_op, r_comp_val = :<=, r_max
			elsif r2 < r
				r_op, r_val, r_max, r_min = :-, r.fdiv(n), r, r2
				r_comp_op, r_comp_val = :>=, r_min
			end

			if g2 > g
				g_op, g_val, g_max, g_min = :+, g2.fdiv(n), g2, g
				g_comp_op, g_comp_val = :<=, g_max
			elsif g2 < g
				g_op, g_val, g_max, g_min = :-, g.fdiv(n), g, g2
				g_comp_op, g_comp_val = :>=, g_min
			end

			if b2 > b
				b_op, b_val, b_max, b_min = :+, b2.fdiv(n), b2, b
				b_comp_op, b_comp_val = :<=, b_max
			elsif b2 < b
				b_op, b_val, b_max, b_min = :-, b.fdiv(n), b, b2
				b_comp_op, b_comp_val = :>=, b_min
			end

			if line_length != n || rotate
				line_length = n
				colours.clear

				i = -1
				while (i += 1) < n
					if exclude_spaces
						_c = c[i]

						if !(_c == ?\s.freeze || _c == ?\t.freeze)
							_r = _r.send(r_op, r_val) if r_comp_op && _r.send(r_comp_op, r_comp_val)
							_g = _g.send(g_op, g_val) if g_comp_op && _g.send(g_comp_op, g_comp_val)
							_b = _b.send(b_op, b_val) if b_comp_op && _b.send(b_comp_op, b_comp_val)
						end
					else
						# We also have duplication above,
						# But we are not going to remove this code unless
						# we find some efficient solution. Using a proc or method
						# for setting these values and calling that is a way
						# to make code slower.
						_r = _r.send(r_op, r_val) if r_comp_op && _r.send(r_comp_op, r_comp_val)
						_g = _g.send(g_op, g_val) if g_comp_op && _g.send(g_comp_op, g_comp_val)
						_b = _b.send(b_op, b_val) if b_comp_op && _b.send(b_comp_op, b_comp_val)
					end

					r_to_i = _r.to_i
					g_to_i = _g.to_i
					b_to_i = _b.to_i

					colours << [
						r_to_i < 0 ? 0 : r_to_i > 255 ? 255 : r_to_i,
						g_to_i < 0 ? 0 : g_to_i > 255 ? 255 : g_to_i,
						b_to_i < 0 ? 0 : b_to_i > 255 ? 255 : b_to_i,
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
		# Duplicate colour, even if colour is nil
		colour = hex && hex.dup.to_s || ''
		colour.strip!
		colour.downcase!
		colour[0] = ''.freeze if colour[0] == ?#.freeze

		# out of range
		oor = colour.scan(/[^a-f0-9]/)

		unless oor.empty?
			invalids = colour.chars.map { |x|
				oor.include?(x) ? "\e[1;31m#{x}\e[0m" : x
			}.join

			puts "Hex Colour ##{invalids} is Out of Range"
			raise ArgumentError
		end

		clen = colour.length
		if clen == 3
			colour.chars.map { |x| x.<<(x).to_i(16) }
		elsif clen == 6
			colour.chars.each_slice(2).map { |x| x.join.to_i(16) }
		else
			sli = clen > 6 ? 'too long'.freeze : clen < 3 ? 'too short'.freeze : 'invalid'.freeze
			raise ArgumentError, "Invalid Hex Colour ##{colour} (length #{sli})"
		end
	end
end
