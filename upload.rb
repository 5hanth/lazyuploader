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

	def upload_to_fb

		puts "\nPhotos : "
		system 'ls'	
		print "\nAre you sure you want to upload these photos to Facebook ? <y,n> "
		c = gets.chomp

		if c.upcase == 'Y'  

				me = FbGraph::User.me(ACCESS_TOKEN)
				album_name = File.basename(Dir.pwd)
				puts "Creating new album '#{album_name}' ..."
				album = me.album!( :name => album_name )


				Dir["*"].each do |file| 
					puts "Uploading #{file} ..... "
					album.photo!( 
							:access_token=>ACCESS_TOKEN, 
							:source=>File.new( file ), 
							:message=>File.basename( file, File.extname(file) )
						    )
				end
			else exit
		end

		puts "Photos Successfully uploaded to Facebook."
	end
end

# ------- Main -------

	lazy_guy = Uploader.new
	lazy_guy.upload_to_fb
