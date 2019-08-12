class JsonWebToken
  SALT = "this-too-shall-pass"

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SALT)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SALT)[0]
    HashWithIndifferentAccess.new decoded
  end
end
