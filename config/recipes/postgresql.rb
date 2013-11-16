set_default(:postgresql_host, "127.0.0.1")
set_default(:postgresql_user) { Capistrano::CLI.ui.ask("PostgreSQL User: ") }
set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
set_default(:postgresql_database) { "#{application}_production" }

namespace :postgresql do
  desc "Install the latest stable release of PostgreSQL."
  task :install, roles: :db, only: {primary: true} do
    sudo "add-apt-repository ppa:pitti/postgresql"
    sudo "apt-get -y update"
    sudo "apt-get -y install postgresql-9.2 libpq-dev"
    run %Q{echo "PATH=\PATH:/etc/init.d/postgres" >> ~/.bashrc} # NOTICE: is this line necessary ??
  end
  after "deploy:install", "postgresql:install"

  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    run %Q{sudo -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
    run %Q{sudo -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
  end
  after "deploy:setup", "postgresql:create_database"

  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "postgresql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "postgresql:symlink"
end
