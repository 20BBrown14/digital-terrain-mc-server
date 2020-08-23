class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :address
      t.string :title
      t.string :key
      t.boolean :isFeatured

      t.timestamps
    end
  end
end
