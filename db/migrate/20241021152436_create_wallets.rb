class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.integer :amount
      t.belongs_to :user
      t.belongs_to :source
      t.belongs_to :target
      t.string :type
      t.string :notes
      t.string :transaction_type

      t.timestamps
    end
  end
end
