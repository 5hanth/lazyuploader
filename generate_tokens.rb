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


require 'flickraw'

class Generator

	def Generator::generate_flickr_tokens

		FlickRaw.api_key = FLICKR_APP_KEY
		FlickRaw.shared_secret = FLICKR_APP_SECRET

		token = flickr.get_request_token
		auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

		puts "Open this url in your process to complete the authication process : \n#{auth_url}"
		puts "Copy here the number given when you complete the process."
		verify = gets.strip

		begin
			flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
			login = flickr.test.login
			puts "You are now authenticated as #{login.username} "
			puts "copy these lines to your config file ~/.access "
			puts "FLICKR_USER_TOKEN = '#{flickr.access_token}'\nFLICKR_USER_SECRET = '#{flickr.access_secret}'"

		rescue FlickRaw::FailedResponse => e
			puts "Authentication failed : #{e.msg}"
		end
	end
end

Generator.generate_flickr_tokens
