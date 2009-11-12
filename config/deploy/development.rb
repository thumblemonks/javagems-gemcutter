require File.dirname(__FILE__) + "/deploy.rb"

host 'gemcutter@dev.javagems.org', :app, :cron
