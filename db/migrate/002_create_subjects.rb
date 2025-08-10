class CreateSubjects < ActiveRecord::Migration[7.1]
  
  def change
    create_table :subjects do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.text :description
      t.integer :credits, null: false

      t.timestamps
    end
    
    add_index :subjects, :code, unique: true
  end
end
