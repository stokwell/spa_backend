# config valid only for current version of Capistrano
lock "3.8.0"

set :application, "spa_backend"
set :repo_url, "git@github.com:stokwell/spa_backend.git"


# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/spa_backend"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bunble"

namespace :deploy do
  desc 'Restart application'
  task :restart  do
    on roles(:app), in: :sequence, wait: 5 do
    #execute :touch, release_path.join('tmp/restart.txt')
    invoke 'unicorn:restart'  
    end
  end

  desc 'Runs rake db:seed'
  task :seed => [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
end

  after :publishing, :restart 
end
