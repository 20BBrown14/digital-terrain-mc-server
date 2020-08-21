class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :address
      t.string :title
      t.boolean :is_featured

      t.timestamps
    end
  end
end
