class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.boolean :is_admin
      t.string :discord_id

      t.timestamps
    end
  end
end
