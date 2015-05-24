require 'sinatra'
require_relative 'baysian_filter'
class Console<Sinatra::Base
$filter = BaysianFilter.new
set :bind, '127.0.0.1'
set :port, 6668
#set :environment, :production 
  get '/' do
    @doc = params['doc']
    if (params['doc'])
      @point = $filter.parse(@doc,'patioglass')*100
    else
      @point = nil
    end
    erb :index
  end
end

