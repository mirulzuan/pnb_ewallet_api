set :stage, :production
set :branch, :master
set :deploy_to, "/home/dev/pnb_ewallet_api"
server "139.162.50.89", user: "dev", roles: %w{app db}
