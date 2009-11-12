require File.join(File.dirname(__FILE__), "deploy.rb")

host 'gemcutter@javagems.org', :app, :cron

