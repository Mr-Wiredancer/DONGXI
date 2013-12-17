namespace :nginx do
  # NOTICE: we may not use this. ONLY for reference
  task :install, roles: :web do
    sudo "add-apt-repository ppa:nginx/stable"
    sudo "apt-get -y update"
    sudo "apt-get -y install nginx"
  end
  after "deploy:install", "nginx:install"

  task :setup, roles: :web do
    template "nginx_unicorn.erb", "#{shared_path}/system/nginx_unicorn_conf"
    sudo "mv #{shared_path}/system/nginx_unicorn_conf /etc/nginx/sites-available/#{application}"
    sudo "ln -nfs /etc/nginx/sites-available/#{application} /etc/nginx/sites-enabled/#{application}"

    sudo "rm -f /etc/nginx/sites-enabled/default"
    sudo "rm -f /etc/nginx/sites-available/default"

    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    task command, roles: :web do
      sudo "service nginx #{command}"
    end
  end
end
