class CreateTeachers < ActiveRecord::Migration[7.1]

  def change
    create_table :teachers do |t|
      t.string :department, null: false

      t.timestamps
    end
    
    add_index :teachers, :department
  end
end
