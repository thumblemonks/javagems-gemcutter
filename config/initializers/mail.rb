require 'smtp-tls'

ActionMailer::Base.smtp_settings = YAML.load_file(Rails.root + "config/mailer.yml")
