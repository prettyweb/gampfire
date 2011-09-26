class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :topic
      t.string :root_auth_code
      t.integer :last_message_id
      t.boolean :private

      t.timestamps
    end
  end
end
