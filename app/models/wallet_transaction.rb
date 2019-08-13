class WalletTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :source_wallet, class_name: "Wallet"
  belongs_to :target_wallet, class_name: "Wallet"

  validates :amount, presence: true

  def as_json(options = {})
    hash = {}
    hash["id"] = id
    hash["user_id"] = user_id
    hash["source_wallet_id"] = source_wallet_id
    hash["target_wallet_id"] = target_wallet_id
    hash["amount"] = amount
    hash["type"] = type
    hash["date"] = created_at.strftime("%Y-%m-%d")
    hash["time"] = created_at.strftime("%H:%M %p")

    return hash
  end
end
