# frozen_string_literal: true

require 'grpc'
require 'mecab_services_pb'

# add Natto::MeCabNode specified enum
module Mecabgrpc
  class ResponseNode
    # Normal MeCab node defined in the dictionary, c.f. `stat`.
    NOR_NODE = 0
    # Unknown MeCab node not defined in the dictionary, c.f. `stat`.
    UNK_NODE = 1
    # Virtual node representing the beginning of the sentence, c.f. `stat`.
    BOS_NODE = 2
    # Virutual node representing the end of the sentence, c.f. `stat`.
    EOS_NODE = 3
    # Virtual node representing the end of an N-Best MeCab node list, c.f. `stat`.
    EON_NODE = 4
  end
end

# utility for gRPC MeCab Server
class MeCabClient
  def initialize
    @stub = Mecabgrpc::MecabService::Stub.new('mecab:8000', :this_channel_is_insecure)
  end

  def parse(string)
    request_string = Mecabgrpc::RequestString.new(body: string)
    responses = @stub.parse(request_string)
    responses.each do |r|
      yield r
    end
  end
end

mc = MeCabClient.new
test_string = '8月3日に放送された「中居正広の金曜日のスマイルたちへ」(TBS系)で、1日たった5分でぽっこりおなかを解消するというダイエット方法を紹介。キンタロー。のダイエットにも密着。'
mc.parse(test_string) do |node|
  puts "#{node.surface}:#{node.feature}"
end