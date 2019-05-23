class User < ApplicationRecord
  has_many :pages

	def self.from_omniauth(auth)
	  require 'net/http'
    require 'uri'
    require 'json'
    
    uri = URI.parse("https://graph.facebook.com/v2.10/oauth/access_token?grant_type=fb_exchange_token&client_id=#{ENV['FB_APP_ID']}&client_secret=#{ENV['FB_APP_SECRET']}&fb_exchange_token=#{auth.credentials.token}")
    response = Net::HTTP.get_response(uri)
	  
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.profile_pic = auth.info.image
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.oauth_token = JSON.parse(response.body)["access_token"]
      user.oauth_expires_at = Time.at(auth.credentials.expires_at) unless auth.credentials.expires_at.nil?
      user.save!
    end
  end
end
