class AddEchoEnabledToPage < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :echo, :boolean
  end
end
