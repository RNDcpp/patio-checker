require_relative 'tweetdb'
if(ARGV[0]){
  TweetDB.create(ARGV[0])
}else{
  puts 'command : create_table [screen-name]'
}
