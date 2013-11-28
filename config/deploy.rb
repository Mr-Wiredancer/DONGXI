require "rvm/capistrano"
require "bundler/capistrano"
#server "115.29.192.209", :web, :app, :db, primary: true
role :web, "115.29.192.209", "192.168.1.99"
role :app, "115.29.192.209", "192.168.1.99"
role :db, "115.29.192.209", "192.168.1.99" # WARNING: one database?
server "192.168.1.99", :db, primary: true

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

after "deploy:setup", "deploy:setup_config"
after "deploy:cold", "deploy:db:seed"
before "deploy", "deploy:check_revision"
after "deploy", "deploy:cleanup" # keep only last 5 releases
after "deploy:finalize_update", "deploy:symlink_config", "deploy:mkdir_dot_test"
after "deploy:finalize_update" do
  run "ln -s #{shared_path}/ckeditor_assets #{release_path}/public/ckeditor_assets"
  run "ln -s #{shared_path}/content #{release_path}/public/content"
end

namespace :deploy do

  task :default do
    update_code
    create_symlink
    server.stop
    db.migrate
    server.start
  end

  # server
  namespace :server do
    %w[start stop].each do |command|
      desc "#{command} server: unicorn & nginx"
      task command, roles: :app, except: { no_release: true } do
        run "/etc/init.d/unicorn_#{application} #{command}"
        #unicorn_rails
        #sudo "service nginx #{command}"
      end
    end
    task :restart, roles: :app do
      run "kill -USR2 `cat #{deploy_to}/shared/pids/unicorn.pid`"
    end
    task :start_webrick_dev, roles: :app do
      run "cd #{current_path}; RAILS_ENV=development bundle exec rails s"
    end
    task :start_webrick_pro, roles: :app do
      run "cd #{current_path}; RAILS_ENV=production bundle exec rails s"
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
    run "mkdir -p #{shared_path}/ckeditor_assets"
    run "mkdir -p #{shared_path}/content"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"

    # set user & passwd for database
    set :db_user, Capistrano::CLI.ui.ask("Application database user: ")
    set :db_pass, Capistrano::CLI.password_prompt("Password: ")
    run "sed -i 's!USERNAME!#{db_user}!' #{shared_path}/config/database.yml"
    run "sed -i 's!PASSWORD!#{db_pass}!' #{shared_path}/config/database.yml"

    put File.read("config/application.yml"), "#{shared_path}/config/application.yml"
    puts "Now edit the config files in #{shared_path}"
  end

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
  task :mkdir_dot_test, roles: :app do
    run "mkdir -p /home/#{user}/.test"
    run "mkdir -p /home/#{user}/.test/pids"
    run "mkdir -p /home/#{user}/.test/log"
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :app do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts 'WARNING: HEAD is not the same as origin/master'
      puts "Run `git push` to sync changes."
      exit
    end
  end

  ### database
  namespace :db do
    %w(drop create migrate seed).each do |command|
      task command, roles: :app do
        run "cd #{current_path}; RAILS_ENV=production rake db:#{command}"
      end
    end
    task :reset, roles: :app do
      drop
      create
      migrate
      seed
    end
  end

end

