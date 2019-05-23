class Post < ApplicationRecord
  has_many :comments
  belongs_to :page
  
  def self.create_post(page_id, post_id, message, image)
    where(post_id: post_id).first_or_initialize.tap do |post|
      post.page_id = page_id
      post.post_id = post_id
      post.image = image
      post.message = message
      post.echo = true
      post.save!
    end
  end
end
