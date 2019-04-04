require './lib/twitter_api'
require './db/db_access'
require 'natto'
nat = Natto::MeCab.new
wc = 0
words = Hash.new
TwitterAPI.init('config.yml')
loop do
begin
TwitterAPI.connect_stream do |line|
if(line.text !~ /^RT/)
  puts line.text
  nat.parse(line.text) do |word|
   if (word.surface =~ /\S+/)and (word.surface !~ /(@.*|_.*|\..*|\/.*|:.*|\(.*|\/.*|\).*|#.*|%.*|\s)/)and((word.surface.length != 1)or(word.surface !~ /[0-9]|[a-z]|[A-Z]|[あ-ん]|[ア-ン]/)) and (word.feature =~ /(名詞|形容詞|動
詞|形容動詞)/) and word.surface.length < 8
      words[word.surface]||=0
      words[word.surface]+=1
      wc+=1
   end 
  end
  if wc > 500
    words.each do |surface,num|
      puts "push to database #{surface}:#{num}"
      DataBase.c_word_add('others',surface,num)
      #DataBase.get_user_id('others')
      #DataBase.get_word_id(surface)
      p DataBase.c_word('others',surface)
      words.delete(surface)
    end
    wc = 0
    words = nil
    words = Hash.new
    puts"-------------------------------------------------------------" 
  end
end
end
rescue => e
puts e.message
end
end
