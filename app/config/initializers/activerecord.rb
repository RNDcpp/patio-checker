require 'active_record'

config = Config::load_yaml('config/database.yml')
env = ENV.fetch('APP_ENV', 'development')
ActiveRecord::Base.establish_connection(config[env])
ActiveRecord::Base.time_zone_aware_attributes = true
puts 'ROAD ACTIVE RECORD CONFIG'
