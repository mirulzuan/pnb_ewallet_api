class Wallet < ApplicationRecord
  attr_accessor :pin
  attr_accessor :amount_transferred

  belongs_to :user
  has_many :debit_txns, class_name: "Debit", foreign_key: "source_wallet_id"
  has_many :credit_txns, class_name: "Credit", foreign_key: "target_wallet_id"

  validate :balance
  validate :pin_entered, on: :update
  validates :amount_transferred, presence: true, numericality: { greater_than: 0 }, on: :update

  def transactions
    WalletTransaction
      .where("source_wallet_id = ? OR target_wallet_id = ?", id, id)
      .where.not("source_wallet_id = ? AND type = ?", id, "Credit")
      .where.not("target_wallet_id = ? AND type = ?", id, "Debit")
      .order("created_at DESC")
  end

  def as_json(options = {})
    hash = {}
    hash["id"] = id
    hash["credit"] = credit
    hash["transactions"] = transactions.as_json
    hash["owner"] = {}
    hash["owner"]["type"] = user.role
    hash["owner"]["name"] = user.name

    return hash
  end

  def temp_pin
    return "123456"
  end

  private

  def balance
    if credit < 0
      errors.add(:wallet, "has insufficient balance")
    end
  end

  def pin_entered
    if pin != temp_pin
      errors.add(:wallet, "PIN is incorrect")
    end
  end
end
