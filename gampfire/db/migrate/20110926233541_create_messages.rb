class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :room_id
      t.string :body

      t.timestamps
    end
  end
end
