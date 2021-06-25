class String
	# Fast conversion to RGB when Integer is passed.
	# For example: 0xffffff for white,
	# 0x000000 or 0x0 for black, 0x00aa00 for deep green
	# 0xff50a6 for pink, 0xff5555 for light red, etc.
	#
	# Similarly:
	# (255 * 256 * 256) + (255 * 256) + (255) => 0xffffff
	# (0 * 256 * 256) + (0 * 256) + 0 => 0x0
	# (255 * 256 * 256) + (85 * 256) + 85 => #ff5555
	# (85 * 256 * 256) + (85 * 256) + 255 => #5555ff
	# (255 * 256 * 256) + (170 * 256) + 0 => 0xffaa00
	# (0 * 256 * 256) + (170 * 256) + 0 => 0x00aa00
	def hex_to_rgb(hex)
		return [
			255 & hex >> 16,
			255 & hex >> 8,
			255 & hex
		] if hex.is_a?(Integer)

		# Duplicate colour, even if colour is nil
		# This workaround is for Ruby 2.0 to Ruby 2.2
		# Which won't allow duplicate nil.
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

			raise ArgumentError, "\e[0mHex Colour \e[1m##{invalids} is Out of Range\e[0m"
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

	private(:hex_to_rgb)
end
