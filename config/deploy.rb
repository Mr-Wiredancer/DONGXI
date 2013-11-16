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
    db.reset # FIXME: should use db.migrate, when db structure is stable
    #server.restart
    unicorn.restart
  end

  # server
  #namespace :server do
    #%w[start stop].each do |command|
      #desc "#{command} server: unicorn & nginx"
      #task command, roles: :app, except: { no_release: true } do
        #run "/etc/init.d/unicorn_#{application} #{command}"
      #end
    #end
    #task :restart, roles: :app do
      #run "kill -USR2 `cat #{pid_dir}/unicorn.pid`"
    #end
    #task :start_webrick_dev, roles: :app do
      #run "cd #{current_path}; RAILS_ENV=development bundle exec rails s"
    #end
    #task :start_webrick_pro, roles: :app do
      #run "cd #{current_path}; RAILS_ENV=production bundle exec rails s"
    #end
  #end

  task :setup_config, roles: :app do
    #put File.read("config/nginx.conf"), "#{shared_path}/system/nginx.conf"
    #sudo "cp #{shared_path}/system/nginx.conf /etc/nginx/nginx.conf"

    # add app-specific nginx conf
    #put File.read("config/nginx.#{application}.conf", "#{shared_path}/system/nginx.#{application}.conf")
    #sudo "cp #{shared_path}/system/nginx.#{application}.conf /etc/nginx/sites-enabled/#{application}"

    #sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    #run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/ckeditor_assets"
    #put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"

    # set user & passwd for database
    #set :db_user, Capistrano::CLI.ui.ask("Application database user: ")
    #set :db_pass, Capistrano::CLI.password_prompt("Password: ")
    #run "sed -i 's!USERNAME!#{db_user}!' #{shared_path}/config/database.yml"
    #run "sed -i 's!PASSWORD!#{db_pass}!' #{shared_path}/config/database.yml"

    put File.read("config/application.yml"), "#{shared_path}/config/application.yml"
    puts "Now edit the config files in #{shared_path}"
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
    run "ln -s #{shared_path}/ckeditor_assets #{release_path}/public/ckeditor_assets"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  task :mkdir_dot_test, roles: :app do
    run "mkdir -p /home/#{user}/.test"
    run "mkdir -p /home/#{user}/.test/pids"
    run "mkdir -p /home/#{user}/.test/log"
  end
  after "deploy:finalize_update", "deploy:mkdir_dot_test"

end

server "192.168.1.99", :web, :app, :db, primary: true
server "115.29.192.209", :web, :app, :db, primary: true
