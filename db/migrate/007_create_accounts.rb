class CreateAccounts < ActiveRecord::Migration[7.1]
  
  def change
    create_table :accounts do |t|

      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :address

      t.references :user, polymorphic: true, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :accounts, :email, unique: true
  end
end
