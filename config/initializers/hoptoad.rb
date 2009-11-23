HoptoadNotifier.configure do |config|
  config.api_key = YAML.load_file((Rails.root + "config/hoptoad.yml"))['key'] #ENV["HOPTOAD_KEY"]
end
