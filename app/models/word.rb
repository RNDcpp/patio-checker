class Word < ActiveRecord::Base
  has_many :word_counts

  class << self
    def find_or_initialize_from(node)
      return unless is_acceptable_feature?(node)
      return unless is_valid_surface?(node)
      return if is_kana_or_alphanumeric_single_charactor?(node)

      find_by(attributes_from(node)) || new(attributes_from(node))
    end

    def attributes_from(node)
      { surface: node.surface, feature: node.feature }
    end

    def is_valid_surface?(node)
      (node.surface =~ /\S+/) && (node.surface !~ /(@.*|_.*|\..*|\/.*|:.*|\(.*|\/.*|\).*|#.*|%.*|\s)/)
    end

    def is_acceptable_feature?(node)
      (node.feature =~ /(名詞|形容詞|動詞|形容動詞)/)
    end

    def is_kana_or_alphanumeric_single_charactor?(node)
      (node.surface.length == 1) && (node.surface !~ /[0-9]|[a-z]|[A-Z]|[あ-ん]|[ア-ン]/)
    end
  end
end
