require './lib/mecab_client'

mc = MeCabClient.new
test_string = '8月3日に放送された「中居正広の金曜日のスマイルたちへ」(TBS系)で、1日たった5分でぽっこりおなかを解消するというダイエット方法を紹介。キンタロー。のダイエットにも密着。'
mc.parse(test_string) do |node|
  puts "#{node.surface}:#{node.feature}"
end