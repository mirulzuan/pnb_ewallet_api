class Debit < WalletTransaction
  after_create :commit_credit

  def commit_credit
    copy = attributes.except("id", "type")
    Credit.create(copy)
  end
end
