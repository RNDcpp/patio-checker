require 'csv'
require 'sqlite3'
require 'natto'
nat = Natto::MeCab.new
db=SQLite3::Database.new("../db/#{ARGV[1]}.db")
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
CSV.foreach("#{ARGV[0]}")do |row|
  text = row[2]
  nat.parse(text) do |word|
    p word.surface
    if (word.surface =~ /\S+/)and (word.surface !~ /(@.*|_.*|\..*|\/.*|:.*|\(.*|\/.*|\).*|#.*|%.*|\s)/)and((word.surface.length != 1)or(word.surface !~ /[0-9]|[a-z]|[A-Z]|[あ-ん]|[ア-ン]/)) and (word.feature =~ /(名詞|形容詞|動詞|形容動詞)/) and word.surface.length < 8
      words[word.surface]||=0
      words[word.surface]+=1
      wc+=1
    end
  end
end
words.each do |word,num|
db.execute('insert into pword values ( ? , ? )',word,num)
end
db.execute('insert into wcount values ( ? )',wc)
puts 'complete'
puts db.execute('select * from pword order by num asc')
puts db.execute('select * from wcount')
