class CreateEchos < ActiveRecord::Migration[5.1]
  def change
    create_table :echos do |t|

    	t.belongs_to :page
    	t.string :category
    	t.json :kewords, default: []
    	t.json :sentences, default: []
    	t.json :answers, default: []

      t.timestamps
    end
  end
end
