set_default(:smtp_email) { Capistrano::CLI.ui.ask("SMTP EMail User: ") }
set_default(:smtp_password) { Capistrano::CLI.password_prompt("SMTP EMail Password: ") }

namespace :monit do
  desc "Install Monit"
  task :install do
    sudo "apt-get -y install monit"
  end
  after "deploy:install", "monit:install"

  desc "Setup all Monit configuration"
  task :setup do
    monit_config "monitrc", "/etc/monit/monitrc"
    nginx
    postgresql
    unicorn
    syntax
    reload
  end
  after "deploy:setup", "monit:setup"

  task(:nginx, roles: :web) { monit_config "nginx" }
  task(:postgresql, roles: :db) { monit_config "postgresql" }
  task(:unicorn, roles: :app) { monit_config "unicorn" }

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      sudo "service monit #{command}"
    end
  end
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  sudo "mv /tmp/monit_#{name} #{destination}"
  sudo "chown root #{destination}"
  sudo "chmod 600 #{destination}"
end