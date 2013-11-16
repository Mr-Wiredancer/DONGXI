namespace :nginx do
  # NOTICE: we may not use this. ONLY for reference
  task :install, roles: :web do
    sudo "add-apt-repository ppa:nginx/stable"
    sudo "apt-get -y update"
    sudo "apt-get -y install nginx"
  end
  after "deploy:install", "nginx:install"


  task :setup, roles: :web do
    template "nginx_unicorn.erb", "/tmp/nginx_conf"
    sudo "mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
    sudo "rm -f /etc/nginx/sites-enabled/default"
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    task command, roles: :web do
      sudo "service nginx #{command}"
    end
  end
end
