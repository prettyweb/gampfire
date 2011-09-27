class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :auth_code
      t.integer :room_id
      t.string :nickname
      t.boolean :online

      t.timestamps
    end
  end
end
