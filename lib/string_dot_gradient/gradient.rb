class String
	def gradient(colour_start, colour_stop, bg: false, rotate: false)
		colours, line_length = [], -1
		temp = ''

		r, g, b = hex_to_rgb(colour_start)
		r2, g2, b2 = hex_to_rgb(colour_stop)
		init = bg ? 48 : 38

		each_line do |c|
			_r, _g, _b = r, g, b
			n = c.length

			r_meth = r == r2 ? :itself : r2 > r ? [:+, r2.fdiv(n)] : [:-, r.fdiv(n)]
			g_meth = g == g2 ? :itself : g2 > g ? [:+, g2.fdiv(n)] : [:-, g.fdiv(n)]
			b_meth = b == b2 ? :itself : b2 > b ? [:+, b2.fdiv(n)] : [:-, b.fdiv(n)]

			if line_length != n
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
				temp.concat(
					"\e[#{init};2;#{colours[i][0]};#{colours[i][1]};#{colours[i][2]}m#{c[i]}"
				)
			end
			colours.rotate! if rotate

			temp << "\e[0m".freeze
		end

		temp
	end

	private
	def hex_to_rgb(hex)
		colour = hex.dup.to_s
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
