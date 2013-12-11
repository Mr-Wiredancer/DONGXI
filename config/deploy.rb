require "rvm/capistrano"
require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/check"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/database"

set :application, "website"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository,  "git@github.com:Mr-Wiredancer/DONGXI.git"
set :branch, "master"

set :pid_dir, "#{shared_path}/pids"
set :log_dir, "#{shared_path}/log"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only last 5 releases

namespace :deploy do

  task :default do
    update_code
    create_symlink
    unicorn.stop
    db.migrate
    unicorn.start
  end

  task :setup_config, roles: :app do

    run "mkdir -p #{shared_path}/ckeditor_assets"
    run "mkdir -p #{shared_path}/content"

    put File.read("config/application.yml"), "#{shared_path}/config/application.yml"
    puts "Now edit the config files in #{shared_path}"
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
    run "ln -s #{shared_path}/ckeditor_assets #{release_path}/public/ckeditor_assets"
    run "ln -s #{shared_path}/content #{release_path}/public/content"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  task :mkdir_dot_test, roles: :app do
    run "mkdir -p /home/#{user}/.test"
    run "mkdir -p /home/#{user}/.test/pids"
    run "mkdir -p /home/#{user}/.test/log"
  end
  after "deploy:finalize_update", "deploy:mkdir_dot_test"

end

#server "192.168.1.99", :web, :app, :db, primary: true
server "115.29.192.209", :web, :app, :db, primary: true
