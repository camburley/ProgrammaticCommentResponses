class AddEchoResponseToPage < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :echo_response, :json, default: []
  end
end
