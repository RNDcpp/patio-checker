require "sqlite3"
require "pp"
dbo = Hash.new
ARGV.each do |arg|
dbo[arg] = SQLite3::Database.new("#{arg}.db")
end
pp dbo

db = SQLite3::Database.new("word.db")

db.execute("drop table if exists words;")
db.execute("drop table if exists users;")
db.execute("drop table if exists wordcounts;")

db.execute("create table wordcounts (word int,user int,num int);")
db.execute("create table users (name vchar(32) primary key,wc int);")
db.execute("create table words (surface vchar(32) primary key);")

ARGV.each do |arg|
  a=dbo[arg].get_first_row("select num from wcount")[0].to_i
  db.execute("insert into users values( ? , ? )",arg,a)
  a_p = db.get_first_row("select rowid from users where name == ?",arg)[0].to_i
  dbo[arg].execute("select surface,num from pword").each do |t|
    p t
    p t[0]
    p t[1]
    p a_p
  
    wid = db.get_first_row("select ROWID from words where surface == ?",t[0])
    p wid
    db.execute("insert into words values ( ? )",[t[0]]) if wid == nil
    wid = db.execute("select ROWID from words where surface == ?",t[0])
    db.execute("insert into wordcounts values ( ?,?,? )",[wid,a_p,t[1]])
  end
end

p user = db.get_first_row("select ROWID from users where name = ? ",ARGV[1])[0]
p word = db.get_first_row("select ROWID from words where surface = ?","DTM")[0]
p db.execute("select * from wordcounts")
p db.get_first_row("select * from wordcounts where word = ? and user = ?",word,user)

