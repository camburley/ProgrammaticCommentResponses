class Comment < ApplicationRecord
  belongs_to :post
  
  def self.create_comment(post_id, comment_id, sender_name, sender_id, message, tags)
    where(comment_id: comment_id).first_or_initialize.tap do |comment|
      comment.post_id = post_id
      comment.comment_id = comment_id
      comment.sender_name = sender_name
      comment.sender_id = sender_id
      comment.message = message
      comment.tags = tags
      comment.save!
    end
  end
end
