class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
    	t.belongs_to :user
    	t.string :name
    	t.string :category
    	t.string :page_id
    	t.string :oauth_token

      t.timestamps
    end
  end
end