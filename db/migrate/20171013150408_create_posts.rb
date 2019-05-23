class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.belongs_to :page
      t.string :post_id
      t.string :image
      t.string :message
      t.boolean :echo
      
      t.timestamps
    end
  end
end
