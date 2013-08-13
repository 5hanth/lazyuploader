#!/usr/bin/env ruby
config = Dir.home+'/.access'
if File.file? config
load config
else
puts "Configuration File #{config} not found !"
exit
end
require 'fb_graph'

class Uploader

	def fb

		print "Photos : "
		Dir["*"].each do |file|
		print file + "\t"
		end

		puts "\nAre you sure you want to upload these photos to Facebook ? <y,n>"
		c = gets.chomp

		if c.upcase == 'Y'  

			Dir["*"].each do |file| 
			a.photo!( 
					:access_token=>ACCESS_TOKEN, 
					:source=>File.new( file ), 
					:message=>File.basename( file, File.extname(file) )
				)
			end
		else exit
		end

	end
end

# ------- Main -------

bot = Uploader.new
bot.fb
