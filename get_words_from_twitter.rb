require './lib/twitter_api'
TwitterAPI.init(config.yml)
TwitterAPI.connect_stream do |line|
p line
end
