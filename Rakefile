require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

desc "Run all tests and features"
task :default => [:test, :cucumber]

task :cron => ['gemcutter:store_legacy_index']

begin
  require 'vlad'
  Vlad.load :scm => :git, :config => "config/deploy/#{ENV['to'] || 'development'}.rb", :app => nil
rescue LoadError => e
  # Silently pass on a fail loading deploy_whatever - we moved that stuff under a deploy
  # subdir
  unless e.message =~ /config\/deploy_/
    puts "Unable to load Vlad #{e}."
  end
end
