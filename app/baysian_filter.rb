class BaysianFilter
  MIN_WORD_PROB = 0.00000000000000000000000000000000001
  MAX_PROB = 0.995
  MIN_PROB = 0.005
  def initialize
    # @nat = Natto::MeCab.new
  end
  
  def parse(text, screen_name)
    user = User.find_by(name: screen_name)
    all_category_word_count = WordCount.where(user: user).sum(:count)
    all_base_word_count = WordCount.where.not(user: user).sum(:count)
    base_document_count = User.where.not(id: user.id).sum(:document_count)
    category_document_count = user.document_count

    category_word_probs = []
    base_word_probs = []
    document_word_probs = []

    MeCabClient.new.parse(text) do |node|
      word = Word.find_or_initialize_from(node)
      next unless word && word.persisted?
      category_word_count = word.word_counts.find_by(user: user)&.count&.to_f || 0.0
      base_word_count = word.word_counts.where.not(user: user).sum(:count)&.to_f || 0.0
      category_word_probs << Math.log([category_word_count / all_category_word_count, MIN_WORD_PROB].max)
      base_word_probs << Math.log([base_word_count / all_base_word_count, MIN_WORD_PROB].max)
      document_word_probs << Math.log([(base_word_count + category_word_count)/(all_category_word_count + all_base_word_count), MIN_WORD_PROB].max)
    end

    log_category_prob = category_word_probs.sum
    log_base_prob = base_word_probs.sum
    log_document_prob = document_word_probs.sum

    log_category_document_prob = Math.log(category_document_count) - Math.log(category_document_count + base_document_count)
    log_base_document_prob = Math.log(base_document_count) - Math.log(category_document_count + base_document_count)

    category_prob = Math.exp(log_category_document_prob + log_category_prob - log_document_prob)
    base_prob = Math.exp(log_base_document_prob - log_document_prob + log_base_prob)
    
    prob = category_prob / (category_prob + base_prob)
    prob = prob > MAX_PROB ? 1 : prob
    prob = prob < MIN_PROB ? 0 : prob

    prob
  end
end

