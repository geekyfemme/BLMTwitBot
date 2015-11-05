require "yaml"
require "bundler/setup"
Bundler.require(:default)

config = YAML.load_file("secrets.yml")

$client = Twitter::REST::Client.new do |c|
  c.consumer_key        = config["consumer_key"]
  c.consumer_secret     = config["consumer_secret"]
  c.access_token        = config["access_token"]
  c.access_token_secret = config["access_token_secret"]
end

# client.search(%{"God", AND "#AllLivesMatter", OR "#BlueLivesMatter"}, result_type: "recent").take(30).each do |tweet|
#   puts tweet.text
# end


def respond_to_tweets
  idstore=YAML.load_file("idstore.yml")
  last_search=idstore["last_search"]
  temp_last_search=0
  responses=YAML.load_file("responses.yml")


  responses.keys.each do |tag|
    options = {:result_type=>"recent"}
    options[:since_id] = last_search if last_search
    $client.search(%{"God", AND "##{tag}"},options).take(5).each do |status|
      begin
        reply=responses[tag].sample
        $client.update("@#{status.user.screen_name} #{reply}",:in_reply_to_status_id=>status.id)
        puts "Replied to: #{status.user.screen_name} (#{status.id}) => #{reply}\n____________________________________________"
        temp_last_search=status.id
      rescue => e
        binding.pry
      end
    end
  end
  if temp_last_search!=0
    idstore["last_search"]=temp_last_search
    File.open("idstore.yml","w") { |file| YAML.dump(idstore,file) }
  end
end

respond_to_tweets


binding.pry
