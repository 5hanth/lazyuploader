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
require 'flickraw'

class Uploader

	def initialize

		puts "\nPhotos :\n "
		@photos = Dir["*"].map { |blah| blah if File.file? blah } #  get array of file names.
		@photos.delete nil
		@photos.each { |file| puts file }

		@total = @photos.count

	end

	def upload_to_fb

		puts "\nUploading Photos to Facebook ..."
		me = FbGraph::User.me(FB_ACCESS_TOKEN)
		album_name = File.basename(Dir.pwd)
		puts "Creating new album '#{album_name}' ..."
		album = me.album!( :name => album_name )

		count = 0

		@photos.each do |file| 
			puts "Uploading #{file} ..... ( #{count = count.next} of #{@total} )"
			album.photo!( 
					access_token: FB_ACCESS_TOKEN, 
					source: File.new( file ), 
					message: File.basename( file, File.extname(file) )
				    ) # remove message: arg if description should not be added to photos.
		end

		puts "Photos Successfully uploaded to Facebook."
	end

	def upload_to_flickr

		puts "\nUploading Photos to Flickr ..."
		FlickRaw.api_key = FLICKR_APP_KEY
		FlickRaw.shared_secret = FLICKR_APP_SECRET
		flickr.access_token = FLICKR_USER_TOKEN
		flickr.access_secret = FLICKR_USER_SECRET

		count = 0

		@photos.each do |file| 
			puts "Uploading #{file} ..... ( #{count = count.next} of #{@total} )"
			flickr.upload_photo file, title: File.basename( file, File.extname(file))
		end

		puts "Photos Successfully uploaded to Flickr."
	end
end

def ask who 
	print "\nAre you sure you want to upload these photos to  #{who} ? <y,n> "
	gets.chomp.upcase == 'Y'
end

# ------- Main -------

	lazy_guy = Uploader.new

	print """
	1. Upload photos to Facebook.
	2. Upload photos to Flickr.
	3. Upload photos to all sites.
	> """

	case gets.chomp.to_i
		when 1 then lazy_guy.upload_to_fb if ask 'Facebook'
		when 2 then lazy_guy.upload_to_flickr if ask 'Flickr'
		when 3 
			if ask 'Facebook & Flickr'
				lazy_guy.upload_to_fb
				lazy_guy.upload_to_flickr
			end
	end


