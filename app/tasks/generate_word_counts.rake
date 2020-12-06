require Config.app_root_path('./services/generate_word_counts.rb')

namespace :generate do
  desc 'generate word_couts from tweets data'
  task :word_counts do
    GenerateWordCounts.generate_word_count
  end
end
