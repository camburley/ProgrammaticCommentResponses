class AddPictureToPages < ActiveRecord::Migration[5.1]
  def change
  	add_column :pages, :picture, :string
  end
end
