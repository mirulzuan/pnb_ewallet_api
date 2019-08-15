# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :rvm_ruby_version, "2.6.1"
set :stages, ["production"]
set :default_stage, "production"
set :application, "pnb_ewallet_api"
set :repo_url, "git@github.com:mirulzuan/pnb_ewallet_api.git"
set :deploy_via, :remote_cache
set :ssh_options, {
  :forward_agent => true,
}
set :linked_files, fetch(:linked_files, []).push(
  "config/database.yml",
  "config/application.yml"
)
set :linked_dirs, fetch(:linked_dirs, []).push(
  "log",
  "tmp/pids",
  "tmp/cache",
  "tmp/sockets",
  "public/uploads"
)

after "deploy:publishing", "deploy:restart"

namespace :deploy do
  task :restart do
    # invoke 'delayed_job:restart'
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end
end
