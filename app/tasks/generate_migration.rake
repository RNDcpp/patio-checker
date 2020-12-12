require 'rake'
require 'time'
require 'erb'
Dir[Config.app_root_path('./models/*.rb')].each {|file| require file }

namespace :generate do
  desc 'generate migration file'
  task :migration, ['action', 'class_name'] => :environment do |task, args|
    create_migration_file(action: args['action'], class_name: args['class_name'])
  end

  AVAILABLE_ACTIONS = %w( create change ).freeze

  class String
    def to_snake
      self.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .downcase
    end
  end

  def create_migration_file(action:, class_name:)
    raise "available actions are in #{AVAILABLE_ACTIONS}" unless AVAILABLE_ACTIONS.include?(action)

    klass = Object.const_get(class_name)
    raise 'Class Not Found' unless klass
    
    migration_context = MigrationContext.new(klass)
    src = ERB.new(IO.read(srcfile(action: action))).result(binding)
    File.write(distfile(action: action, class_name: class_name), src)
    puts "generate #{distfile(action: action, class_name: class_name)}"
  end

  def srcfile(action:)
    File.join(Config.root_path("db/migration_base/#{action}.erb"))
  end

  def distfile(action:, class_name:)
    File.join(Config.app_root_path("migrations/#{filename(action: action, class_name: class_name)}"))
  end

  def filename(action:, class_name:)
    time = Time.now.strftime("%Y%m%d%H%M%S")
    [time, action, class_name.to_snake].join('_') + '.rb'
  end

  class MigrationContext
    attr_reader :class_name, :table_name, :migration_version
    def initialize(klass)
      @migration_version = '5.0'
      @class_name = klass.to_s
      @table_name = klass.table_name
    end
  end
end
