require 'rest-client'
require 'net/http'
require 'uri'

class MessengerController < ApplicationController
  protect_from_forgery with: :null_session
  layout false
    
  class Send
    def post_reply(text, comment_id, page_token)
      data = {
        message: text
      }
      
      url = URI.parse("https://graph.facebook.com/v2.10/#{comment_id}/comments?access_token=#{page_token}")
      
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE #only for development.
      begin
        request = Net::HTTP::Post.new(url.request_uri)
        request["Content-Type"] = "application/json"
        request.body = data.to_json
        response = http.request(request)
        body = JSON(response.body)
        return { ret: body["error"].nil?, body: body }
      rescue => e
        raise e
      end
    end
  end
    
  def callback
    messaging_event = JSON.parse(request.body.read)
    
      
    if messaging_event["entry"][0]["changes"] && messaging_event["entry"][0]["changes"][0]["field"] == "feed"
      
      if Page.find_by(:page_id =>  messaging_event["entry"][0]["id"], :echo => true) 
        messaging_event["entry"][0]["changes"].each do |msg|
          
          post_id = msg["value"]["post_id"]
          comment_id = msg["value"]["comment_id"]
          sender_name = msg["value"]["sender_name"]
          sender_id = msg["value"]["sender_id"]
          page_id = messaging_event["entry"][0]["id"]
          message = msg["value"]["message"] if msg["value"]["message"]
          image = msg["value"]["link"] if msg["value"]["link"]
          
          if Post.find_by(:post_id => post_id) && msg["value"]["verb"] == "add"
            page = Page.find_by(:page_id => page_id)
            post = Post.find_by(:post_id => post_id)
            
            if msg["value"]["item"] == "status" || msg["value"]["item"] == "photo"
              Post.create_post(page.id, post_id, message, image)
            elsif post.echo == true && page.page_id != sender_id && msg["value"]["item"] == "comment"
              uri = URI.parse("https://graph.facebook.com/v2.10/#{comment_id}?fields=message_tags&access_token=#{page.oauth_token}")
              response = Net::HTTP.get_response(uri)
              tags = JSON.parse(response.body)
              
              Comment.create_comment(post.id, comment_id, sender_name, sender_id, message, tags)
              
              if tags && tags["message_tags"] && page.echo_response.any?
                Send.new.post_reply(page.echo_response.sample, comment_id, page.oauth_token)
              end
            end
          end
        end
        
        return false
      end
    end
  end
    
  def verify_callback
      challenge = params["hub.challenge"]
      verify_token = params["hub.verify_token"]
        
      if verify_token == "thought_you_d_ping_me"
        render :json => challenge
      else
        redirect_to root_path
      end
  end
end
