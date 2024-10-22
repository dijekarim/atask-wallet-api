class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.integer :amount
      t.belongs_to :user
      t.string :type
      t.string :notes

      t.timestamps
    end
  end
end
