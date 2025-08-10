class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :major
      t.integer :year, null: false

      t.timestamps
    end
    
    add_index :students, :student_id, unique: true
  end
end
