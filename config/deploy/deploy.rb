#
# General configuration
#

$: << File.dirname(__FILE__)
require 'lib/vlad_break_patch'

set :application,           'gemcutter'
set :ssh_flags,             "-l#{application}"
set :deploy_to,             "/var/app/#{application}"

set :repository,            "git://github.com/thumblemonks/javagems-gemcutter.git"
set :revision,              ENV['REV'] || "origin/master"
set :git_use_submodules,    true

set :stage,                 ENV['to'] || 'development'
set :rails_env,             stage

namespace :vlad do

  remote_task :symlink_configs, :roles => :app do
    %w[database.yml aws-s3.yml mailer.yml session.yml].each do |conf_file|
      run "ln -fs #{shared_path}/config/#{conf_file} #{latest_release}/config/#{conf_file}"
    end
  end

  remote_task :restart, :roles => :app do
    puts "Restarting the app..."
    run("touch #{current_path}/tmp/restart.txt")
  end
  
  remote_task :bundle_gems, :roles => :app do
    run(%Q[cd "#{current_path}" && gem bundle])
  end

  task :deploy => [:update, :symlink_configs, :bundle_gems, :migrate, :restart]
end
