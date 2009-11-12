AWS::S3::Base.establish_connection!(
  YAML.load_file(Rails.root + "config/aws-s3.yml")
)

class ::VaultObject < AWS::S3::S3Object
  set_current_bucket_to "javagems_#{(ENV['RACK_ENV'] || RAILS_ENV).downcase}"
end
