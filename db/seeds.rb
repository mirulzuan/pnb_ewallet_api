roles = ["user", "team", "stock"]

roles.each do |role|
  3.times do |i|
    name = "#{role}#{i + 1}"

    User.create(
      role: role,
      name: name,
      email: "#{name}@test.com",
      password: "password",
      password_confirmation: "password",
      wallets_attributes: [
        {
          credit: rand(1000.00..10000.99),
        },
        {
          credit: rand(1000.00..10000.99),
        },
      ],
    )
  end
end
