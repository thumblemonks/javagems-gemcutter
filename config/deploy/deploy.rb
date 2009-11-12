#
# General configuration
#

$: << File.dirname(__FILE__)
require 'lib/vlad_break_patch'

set :application,           'gemcutter'
set :ssh_flags,             "-l#{application}"
set :deploy_to,             "/var/app/#{application}"

set :repository,            "git://github.com/javagems/gemcutter.git"
set :revision,              ENV['REV'] || "origin/master"
set :git_use_submodules,    true

set :stage,                 ENV['to'] || 'development'
set :rails_env,             stage

namespace :vlad do

  remote_task :symlink_configs, :roles => :app do
     run "ln -fs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
     run "ln -fs #{shared_path}/config/aws-s3.yml #{latest_release}/config/aws-s3.yml"
  end

  remote_task :restart, :roles => :app do
    puts "Restarting the app..."
    run("touch #{current_path}/tmp/restart.txt")
  end

  task :deploy => [:update, :symlink_configs, :migrate, :restart]
end