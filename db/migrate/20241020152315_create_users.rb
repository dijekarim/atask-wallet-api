class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :salt
      t.string :password_digest
      t.string :type

      t.timestamps
    end
  end
end
