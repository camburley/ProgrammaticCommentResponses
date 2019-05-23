class Page < ApplicationRecord
	belongs_to :user
	has_many :posts
	has_many :echos

	def self.add_pages(user_id)
		require 'net/http'
		require 'uri'
		require 'json'

		user = User.find(user_id)
		
		uri = URI.parse("https://graph.facebook.com/v2.10/#{user.uid}/accounts?fields=picture,name,access_token,category&access_token=#{user.oauth_token}")
		response = Net::HTTP.get_response(uri)
		@pages = JSON.parse(response.body)
		
		unless @pages.nil?
			@pages["data"].each do |data|
				
				uri = URI.parse("https://graph.facebook.com/v2.10/oauth/access_token?grant_type=fb_exchange_token&client_id=#{ENV['FB_APP_ID']}&client_secret=#{ENV['FB_APP_SECRET']}&fb_exchange_token=#{data["access_token"]}")
	    	response = Net::HTTP.get_response(uri)
	    	token = JSON.parse(response.body)["access_token"]
	
				where(user_id: user.id, page_id: data["id"]).first_or_initialize.tap do |page|
					page.user_id = user_id
					page.name = data["name"]
					page.category =  data["category"]
					page.page_id = data["id"]
					page.oauth_token = token
					page.picture = data["picture"]["data"]["url"]
					page.save!
				end
			end
		end
	end
end