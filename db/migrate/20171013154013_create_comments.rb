class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      
      t.belongs_to :post
      t.string :sender_name
      t.string :sender_id
      t.string :comment_id
      t.string :message
      
      t.timestamps
    end
  end
end
