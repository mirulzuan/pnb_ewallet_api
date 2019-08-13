class Wallet < ApplicationRecord
  belongs_to :user
  has_many :debit_txns, class_name: "Debit", foreign_key: "source_wallet_id"
  has_many :credit_txns, class_name: "Credit", foreign_key: "target_wallet_id"

  def transactions
    WalletTransaction.where("source_wallet_id = ? OR target_wallet_id = ?", id, id)
  end

  def as_json(options = {})
    hash = {}
    hash["id"] = id
    hash["credit"] = credit
    hash["transactions"] = transactions.as_json

    return hash
  end
end
