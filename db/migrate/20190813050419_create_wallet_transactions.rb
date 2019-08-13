class CreateWalletTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :wallet_transactions, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.references :source_wallet, foreign_key: { to_table: "wallets" }, type: :uuid
      t.references :target_wallet, foreign_key: { to_table: "wallets" }, type: :uuid
      t.decimal :amount, precision: 10, scale: 2, default: 0.00
      t.string :type

      t.timestamps
    end
  end
end
