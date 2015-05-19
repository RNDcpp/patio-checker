require'sqlite3'
module DataBase
  class << self
  $db = SQLite3::Database.new('db/word.db')
    def get_user_id(name)
      ret = nil
      if(u=$db.get_first_row("select ROWID from users where name = ?",[name]))
        ret = u[0]
      end
      return ret
    end
    def get_word_id(surface)
      ret = nil
      if(u=$db.get_first_row("select ROWID from words where surface = ?",[surface]))
        p ret = u[0]
      end
      return ret
    end
    def c_word(name,surface)
      uid = get_user_id(name)
      wid = get_word_id(surface)
      ret = 1
      if wordc = $db.get_first_row("select * from wordcounts where word = ? and user = ?",[wid,uid])
        p ret += wordc[2]
      end
      return ret
    end
    def wc(name)
      if u = $db.get_first_row("select wc from users where name = ?",[name])
        u = u[0]+$db.get_first_row("select count(*) from wordcounts where user = ?",[get_user_id(name)])[0]
      end
      return u
    end
    def u_wc(name)
      if u = $db.get_first_row("select sum(wc) from users where name != ?",[name])[0]
        u = u[0]+$db.get_first_row("select count(*) from wordcounts")[0]
      end
      return u
    end
    def u_c_word(name,surface)
      uid = get_user_id(name)
      wid = get_word_id(surface)
      ret = 1
      if wordc = $db.get_first_row("select sum(num) from wordcounts where word = ? and user != ?",[wid,uid])[0]
         ret += wordc
      end
      return ret
    end
    def c_word_add(name,surface,num)
      uid = get_user_id(name)
      if uid == nil
        $db.execute("insert into users values(?,?)",[name,num])
        uid = get_user_id(name)
      end
      wid = get_word_id(surface)
      if wid == nil
        $db.execute("insert into words values(?)",[surface])
        wid = get_word_id(surface)
      end
      $db.execute("update users set wc = wc + ? where rowid = ?",[num,uid])
      $db.execute("update wordcounts set num = num + ? where user = ? and word = ?",[num,uid,wid])
    end
  end
end
