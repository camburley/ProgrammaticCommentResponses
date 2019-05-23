class AddPageSelectedToUser < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :page_selected, :integer
  end
end
