set :application, ENV["APP_NAME"]
set :repository,  ENV["APP_REPO"]
set :branch, ENV["BRANCH_NAME"]

role :web, ENV["HOST_IP"]
role :app, ENV["HOST_IP"]
role :db,  ENV["HOST_IP"], :primary => true

set :user, ENV["HOST_USER"]

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user
set :use_sudo, false

set :scm, :git
set :deploy_to, "/var/www/rails/#{application}"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache
set :rack_env, :production
# set :shared_children, shared_children + %w{db}

require 'capistrano_colors'
require "bundler/capistrano"
require 'rvm/capistrano'

# If you had problem with following error
# "no tty present and no askpass program specified", comment this out!
default_run_options[:pty] = true
set :bundle_flags, "--no-deployment"

namespace :deploy do
  task :start do
  	run "cd #{current_path};RACK_ENV=production rackup -D -P /tmp/#{application}.pid"
 	end
  task :stop do
  	run "kill -s SIGINT `cat /tmp/#{application}.pid`"
  end
  task :restart do
		# run "kill -s SIGINT `cat /tmp/#{application}.pid`"
    run "if kill -0 `cat /tmp/#{application}.pid`; then kill -s SIGINT `cat /tmp/#{application}.pid`; else echo \"no\"; fi"
    run "cd #{current_path};RACK_ENV=production rackup -D -P /tmp/#{application}.pid"
  end
end

namespace :bundle do
	task :install do
	end
end