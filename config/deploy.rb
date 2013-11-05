require "rvm/capistrano"
require "bundler/capistrano"
server "192.168.1.103", :web, :app, :db, primary: true

set :application, "website"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository,  "git@github.com:Mr-Wiredancer/DONGXI.git"
set :branch, "master"

set :unicorn_path, "#{current_path}/config/unicorn.rb"
set :pid_dir, "#{shared_path}/pids"
set :log_dir, "#{shared_path}/log"


default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy", "deploy:cleanup" # keep only last 5 releases

namespace :deploy do

  %w[start stop restart].each do |command|
    desc "#{command} server: unicorn & nginx"
    task command, roles: :app, except: { no_release: true } do
      run "/etc/init.d/unicorn_#{application} #{command}"
      #unicorn_rails
      #sudo "service nginx #{command}"
    end
  end

  #desc "Start server"
  #task :start, roles: :app do
    #run "cd #{current_path}; RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_path} -D"
  #end

  #desc "Stop server"
  #task :stop do
    #run "kill -QUIT `cat #{pid_dir}/unicorn.pid`"
  #end

  #desc "Restart server"
  #task :restart, :roles => :app, :except => { :no_release => true } do
    #run "kill -QUIT `cat #{pid_dir}/unicorn.pid`" #if %x(ps aux|grep unicorn | wc -l).strip.to_i > 1
    #run "cd #{current_path}; RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_path} -D"
    ##run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  #end

  task :setup_config, roles: :app do
    put File.read("config/nginx.conf"), "#{shared_path}/system/nginx.conf"
    sudo "cp #{shared_path}/system/nginx.conf /etc/nginx/nginx.conf"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}"
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  task :mkdir_dot_test, roles: :app do
    run "mkdir -p /home/#{user}/.test"
    run "mkdir -p /home/#{user}/.test/pids"
    run "mkdir -p /home/#{user}/.test/log"
  end
  after "deploy:finalize_update", "deploy:symlink_config", "deploy:mkdir_dot_test"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :app do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts 'WARNING: HEAD is not the same as origin/master'
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"

  ### database

  #after "deploy:setup" do
    #run "RAILS_ENV=production rake db:create"
  #end

  after "deploy:cold" do
    # 1st migration is defined in gem.
    run "cd #{current_path}; RAILS_ENV=production rake db:seed"
  end

  task :set_db, roles: :app do
    set :db_user, Capistrano::CLI.ui.ask("Application database user: ")
    set :db_pass, Capistrano::CLI.password_prompt("Password: ")

    run "sed -i 's!\[USERNAME\]!#{db_user}!' #{current_path}/config/database.yml"
    run "sed -i 's!\[PASSWORD\]!#{db_pass}!' #{current_path}/config/database.yml"
  end

  #before "deploy:migration", "deploy:set_db"
  after "deploy:update", "deploy:migrations"

end
