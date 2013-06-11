set :application, "log-viewer"
set :repository,  "git@github.com:a-munakata/log-viewer.git"
set :branch, "munakata"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.1.138"                          # Your HTTP server, Apache/etc
role :app, "192.168.1.138"                          # This may be the same as your `Web` server
role :db,  "192.168.1.138", :primary => true # This is where Rails migrations will run

set :user, "fourdigit"

require 'capistrano_colors'
require "bundler/capistrano"
require 'rvm/capistrano'

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user
set :use_sudo, false

set :scm, :git
set :deploy_to, "/var/www/rails/#{application}"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache
set :shared_children, shared_children + %w{db/}

# If you had problem with following error
# "no tty present and no askpass program specified", comment this out!
default_run_options[:pty] = true
set :bundle_flags, "--no-deployment"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do
  	run "cd #{current_path};rackup -D -P /tmp/#{application}.pid"
 	end
  task :stop do
  	run "kill -s SIGINT `cat /tmp/#{application}.pid`"
  end
  task :restart do
		# run "kill -s SIGINT `cat /tmp/#{application}.pid`"
    run "cd #{current_path};rackup -D -P /tmp/#{application}.pid"
  end
end