require'sqlite3'
require'natto'
class BeysianFilter
  def initialize(cat,base)
    @nat = Natto::MeCab.new
    @cat = SQLite3::Database.new("./db/#{cat}.db")
    @base = SQLite3::Database.new("./db/#{base}.db")
  end
  def parse(text,cat)
    words = Array.new
    @nat.parse(text) do |word|
      if (word.surface =~ /\S+/)and (word.surface !~ /(@.*|_.*|\..*|\/.*|:.*|\(.*|\/.*|\).*|#.*|%.*|\s)/)and((word.surface.length != 1)or(word.surface !~ /[0-9]|[a-z]|[A-Z]|[あ-ん]|[ア-ン]/)) and (word.feature =~ /(名詞|形容詞|動詞|形容動詞)/) and word.surface.length < 8
        words << word.surface
      end
    end
    cat_wc_pure = @cat.execute("select num from wcount").first()[0].to_f
    cat_wc = cat_wc_pure + @cat.execute("select count(*) from pword").first()[0].to_f
    base_wc = @base.execute("select num from wcount").first()[0].to_f + @base.execute("select count(*) from pword").first()[0].to_f
    document_wc = cat_wc+base_wc
    p_cat = Math.log(cat_wc/document_wc)
    p_base = Math.log(base_wc/document_wc)
    
    p_cat_doc = 0
    p_base_doc = 0
    words.each do |word|
      cat_num = @cat.execute("select num from pword where surface=(?)",word).first()[0].to_f + 1 rescue (cat_num = 1)
      p_cat_word = Math.log(cat_num/cat_wc)
      p_cat_doc += p_cat_word
      base_num = @base.execute("select num from pword where surface=(?)",word).first()[0].to_f + 1 rescue (base_num = 1)
      p_base_word = Math.log(base_num/base_wc)
      p_base_doc += p_base_word
    end
    a = Math.exp(p_cat_doc + p_cat - (p_cat_doc + p_base_doc))
    b = Math.exp(p_base_doc + p_cat - (p_cat_doc + p_base_doc))
    return a/(a+b)
  end
end
filter = BeysianFilter.new('patioglass','ABCanG1015')
puts "あなたのぱちお度は\n#{filter.parse(ARGV[0],'patioglass')*100}%"

