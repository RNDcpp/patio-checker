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
    p cat_wc = DataBase.wc(cat).to_f
    p base_wc = DataBase.u_wc(cat).to_f 
    document_wc = base_wc.to_f+cat_wc
    p_cat = Math.log(cat_wc/document_wc)
    p_base = Math.log(base_wc/document_wc)
    
    p_cat_doc = 0
    p_base_doc = 0
    p_doc = 0
    probs = Array.new
    words.each do |word|
      print "#{word}:"
      c_wnum = 2*DataBase.c_word(cat,word).to_f #rescue (c_wnum = 0)
      b_wnum = DataBase.u_c_word(cat,word).to_f #rescue (b_wnum = 0)
      p ""
      p c_wnum||=0
      p b_wnum||=0
      p b_wnum/base_wc
      p 'probability'
      p p_cat_word = ([(c_wnum/cat_wc),1.0].min)/(([c_wnum/cat_wc,1].min)+([b_wnum/base_wc,1].min))
      probs << [p_cat_word,0.99].min
    end
    probs.sort_by!{|p_word|-(p_word-0.5).abs}
    prob_patio = 0
    prob_non_patio = 0
    probs.each_with_index do |pw,id|
      p pw
      prob_patio+=Math.log(pw)
      prob_non_patio+=Math.log(1-pw)
      break if id >= 15
    end
    p_patio = Math.exp(prob_patio)/(Math.exp(prob_patio)+Math.exp(prob_non_patio))
    #puts "p_cat:#{p_cat},p_cat_doc:#{p_cat_doc},p_base_doc:#{p_base},p_base_doc#{p_base_doc}"
    #b = Math.exp(p_base_doc + p_base - (p_doc))
    return p_patio
  end
end

