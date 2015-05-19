require'sqlite3'
require'natto'
require_relative'db/db_access'
class BaysianFilter
  def initialize
    @nat = Natto::MeCab.new
  end
  def parse(text,cat)
    words = Array.new
    @nat.parse(text) do |word|
      if (word.surface =~ /\S+/)and (word.surface !~ /(@.*|_.*|\..*|\/.*|:.*|\(.*|\/.*|\).*|#.*|%.*|\s)/)and((word.surface.length != 1)or(word.surface !~ /[0-9]|[a-z]|[A-Z]|[あ-ん]|[ア-ン]/)) and (word.feature =~ /(名詞|形容詞|動詞|形容動詞)/) and word.surface.length < 8
        words << word.surface
      end
    end
    cat_wc = DataBase.wc(cat).to_f
    base_wc = DataBase.u_wc(cat).to_f 
    document_wc = base_wc.to_f+cat_wc
    p_cat = Math.log(cat_wc/document_wc)
    p_base = Math.log(base_wc/document_wc)
    
    p_cat_doc = 0
    p_base_doc = 0
    words.each do |word|
      p word
      p cat_num = DataBase.c_word(cat,word).to_f rescue (cat_num = 1.0)
      p p_cat_word = Math.log(cat_num/cat_wc)
      p_cat_doc += p_cat_word
      p base_num = DataBase.u_c_word(cat,word).to_f rescue (base_num = 1.0)
      p p_base_word = Math.log(base_num/base_wc)
      p_base_doc += p_base_word
    end
    puts "p_cat:#{p_cat},p_cat_doc:#{p_cat_doc},p_base_doc:#{p_base},p_base_doc#{p_base_doc}"
    a = Math.exp(p_cat_doc + p_cat - (p_cat_doc + p_base_doc))
    b = Math.exp(p_base_doc + p_base - (p_cat_doc + p_base_doc))
    return a/(a+b)
  end
end
filter = BaysianFilter.new
puts "あなたの#{ARGV[0]}度は\n#{filter.parse(ARGV[1],"#{ARGV[0]}")*100}%"

