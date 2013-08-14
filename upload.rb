#!/usr/bin/env ruby

# https://github.com/5hanth/lazyuploader
# mail@shanth.tk

config = Dir.home+'/.access'	# change your config file name accordingly.

if File.file? config
	load config
else
	puts "Configuration File #{config} not found !"
	exit
end

require 'fb_graph'

class Uploader

	def initialize

		puts "\nPhotos :\n "
		system 'ls'	

	end

	def upload_to_fb

		print "\nAre you sure you want to upload these photos to Facebook ? <y,n> "

		if gets.chomp.upcase == 'Y'  

				me = FbGraph::User.me(FB_ACCESS_TOKEN)
				album_name = File.basename(Dir.pwd)
				puts "Creating new album '#{album_name}' ..."
				album = me.album!( :name => album_name )

				photos = Dir["*"].map { |blah| blah if File.file? blah } #  get array of file names.
				photos.delete nil

				count = 0
				total = photos.count

				photos.each do |file| 
					puts "Uploading #{file} ..... ( #{count = count.next} of #{total} )"
					album.photo!( 
							:access_token=>FB_ACCESS_TOKEN, 
							:source=>File.new( file ), 
							:message=>File.basename( file, File.extname(file) )
						    ) # remove :message if description should not be added to photos.
				end
			else exit
		end

		puts "Photos Successfully uploaded to Facebook."
	end
end

# ------- Main -------

	lazy_guy = Uploader.new
	lazy_guy.upload_to_fb
