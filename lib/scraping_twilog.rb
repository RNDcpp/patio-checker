# coding: utf-8
require 'open-uri'
require 'nokogiri'
require 'natto'
require 'sqlite3'
db = SQLite3::Database.new("../db/#{ARGV[0]}.db")
nat = Natto::MeCab.new
module TwilogParser
  class << self
    def get_status_list(screen_name,limit)
      posts = Array.new
      limit.times do |i|
      begin
        html = open("http://twilog.org/#{screen_name}/nort-#{i+1}",'User-Agent'=>'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)') do |f|
          f.read
        end
        puts 'start parse'
        doc = Nokogiri::HTML.parse(html,nil,'UTF-8')
        doc.xpath('//*[@class = "tl-text"]').each do |t|
          puts t.text
          posts << t.text
        end
      rescue => e
      end
        Kernel.sleep(20)
      end
      return posts
    end
  end
end
db.execute("drop table if exists pword;")
db.execute("drop table if exists wcount;")
db.execute <<-SQL
  create table pword (
    surface varchar(16),
    num integer
  );
SQL
db.execute("create table wcount(num int8);")
wc = 0
words = Hash.new
TwilogParser.get_status_list(ARGV[0],ARGV[1].to_i).each do |t|
begin
  nat.parse(t) do |word|
    if (word.surface =~ /\S+/)and (word.surface !~ /(@.*|_.*|\..*|\/.*|:.*|\(.*|\/.*|\).*|#.*|%.*|\s)/)and((word.surface.length != 1)or(word.surface !~ /[0-9]|[a-z]|[A-Z]|[あ-ん]|[ア-ン]/)) and (word.feature =~ /(名詞|形容詞|動詞|形容動詞)/) and word.surface.length < 8
      words[word.surface]||=0
      words[word.surface]+=1
      wc+=1
    end
  end
rescue
end
end
words.each do |word,num|
  puts "#{word}:#{words[word]}"
  {
  "#{word}" => num,
  }.each do |pair|
    db.execute "insert into pword values ( ?, ? )", pair
  end
end
db.execute "insert into wcount values (?)",wc
db.execute( "select * from pword order by num asc" ) do |row|
  p row
end
db.execute( "select * from wcount" ) do |row|
  p row
end

