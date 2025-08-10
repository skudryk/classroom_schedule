class CreateClassrooms < ActiveRecord::Migration[7.1]
  
  def change
    create_table :classrooms do |t|
      t.string :name, null: false
      t.string :building, null: false
      t.integer :capacity, null: false
      t.string :room_number, null: false

      t.timestamps
    end
    
    add_index :classrooms, [:building, :room_number], unique: true
  end
end
