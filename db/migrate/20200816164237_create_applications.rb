class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.string :inGameName
      t.string :discordUsername
      t.numeric :age
      t.string :location
      t.string :joinReason
      t.string :playStyle
      t.string :freeTime
      t.string :status
      t.json :source

      t.timestamps
    end
  end
end
