namespace :nodejs do
  desc "Install the latest release of Node.js"
  task :install, roles: :app do
    sudo "add-apt-repository ppa:chris-lea/node.js"
    sudo "apt-get -y update"
    sudo "apt-get -y install nodejs"
  end
  after "deploy:install", "nodejs:install"
end
