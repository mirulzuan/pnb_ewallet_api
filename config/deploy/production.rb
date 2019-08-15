set :stage, :production
set :branch, :production
set :deploy_to, "/home/dev/pnb_ewallet_api"
server "139.162.50.89", user: "dev", roles: %w{app db}
