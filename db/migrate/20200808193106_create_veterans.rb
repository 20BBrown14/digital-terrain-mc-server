class CreateVeterans < ActiveRecord::Migration[6.0]
  def change
    create_table :veterans do |t|
      t.json :veteransInformation

      t.timestamps
    end
  end
end
