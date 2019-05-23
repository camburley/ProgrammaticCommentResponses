class AddTagsToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :tags, :json
  end
end
