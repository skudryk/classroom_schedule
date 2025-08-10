class CreateEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :enrollments do |t|
      t.references :student, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true

      t.date :enrollment_date, null: false
      t.string :status, null: false, default: 'enrolled'

      t.timestamps
    end
    
    add_index :enrollments, [:student_id, :section_id], unique: true
    add_index :enrollments, :status
  end
end
