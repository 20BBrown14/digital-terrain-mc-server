class CreateServerInformations < ActiveRecord::Migration[6.0]
  def change
    create_table :server_informations do |t|
      t.json :serverInformation

      t.timestamps
    end
  end
end
