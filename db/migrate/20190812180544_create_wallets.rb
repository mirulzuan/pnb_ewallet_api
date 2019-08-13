class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.decimal :credit, precision: 10, scale: 2, default: 0.00

      t.timestamps
    end
  end
end
