require "yaml"
require "bundler/setup"
Bundler.require(:default)

config = YAML.load_file("secrets.yml")

client = Twitter::REST::Client.new do |c|
  c.consumer_key        = config["consumer_key"]
  c.consumer_secret     = config["consumer_secret"]
  c.access_token        = config["access_token"]
  c.access_token_secret = config["access_token_secret"]
end

binding.pry
