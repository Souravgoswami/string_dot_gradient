# Encoding: UTF-8

require "bundler/setup"
require "string_dot_gradient"

words = IO.readlines(File.join(__dir__, 'words')).join
reliable_match = IO.read(File.join(__dir__, 'reliable_match.data'), encoding: 'UTF-8').strip

real_t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
cpu_t1 = Process.times

gradients = words.gradient(
	'55f', '#3eb', '#55f', 'FEC40E', 'E93884', '55f', '55f', '000', '555'
).strip.inspect

real_t2 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
t2 = Process.times

real_time = real_t2 - real_t1
cpu_time = t2.stime.+(t2.utime).-(cpu_t1.stime + cpu_t1.utime)

if reliable_match == gradients
	puts "\e[1;38;2;0;170;0m\u2714  Test Passed!\e[0m"
	puts "\e[38;2;255;255;0m\u23F2  CPU Time: #{"%05.3f" % cpu_time}\e[0m"
	puts "\e[38;2;255;255;0m\u23F2  Real Time: #{"%05.3f" % real_time}\e[0m"
else
	j = 0
	gradients.each_char.with_index { |x, i|
		unless x == reliable_match[i]
			puts "Expected #{gradients[i - 5 .. i + 5]} | Got #{reliable_match[i - 5 .. i + 5]}"
			j += 1
		end

		break if j == 10
	}

	puts "\e[1;38;2;255;80;80m\u2717 Test Failed.\e[0m"

	exit 1
end
