class User < ApplicationRecord
  has_secure_password

  enum role: [:user, :team, :stock]

  has_many :wallets, dependent: :destroy
  accepts_nested_attributes_for :wallets

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :role, presence: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  def as_json(options = {})
    hash = {}
    hash["id"] = id
    hash["email"] = email
    hash["name"] = name
    hash["role"] = role
    hash["wallets"] = wallets

    return hash
  end
end
