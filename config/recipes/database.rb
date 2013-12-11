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
after "deploy:cold", "db:seed"
