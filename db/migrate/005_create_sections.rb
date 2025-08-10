class CreateSections < ActiveRecord::Migration[7.1]
  def change
    create_table :sections do |t|

      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true

      t.time :start_time, null: false
      t.time :end_time, null: false

      t.string :days_of_week, array: true, null: false
      t.integer :duration_minutes, null: false
      t.integer :capacity, null: false

      t.timestamps
    end
    
    add_index :sections, [:start_time, :end_time]
    add_index :sections, :days_of_week
    add_index :sections, :capacity
  end
end
