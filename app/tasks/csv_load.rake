require Config.app_root_path('./services/csv_loader.rb')

namespace :csv do
  desc 'load csv file'
  task :load, ['filename', 'type', 'screen_name'] => :environment do |task, args|
    CsvLoader.instance(type: args['type'], screen_name: args['screen_name']).load_csv(args['filename'])
  end

  desc 'load twilog csv directory'
  task :load_twilog do
    Dir[Config.app_root_path('./input/twilog/*.csv')].each do |file|
      puts "load #{file}"
      CsvLoader.instance(type: 'twilog').load_csv(file)
    end
  end
end