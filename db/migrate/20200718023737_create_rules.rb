class CreateRules < ActiveRecord::Migration[6.0]
  def change
    create_table :rules do |t|
      t.json :rules

      t.timestamps
    end
  end
end
