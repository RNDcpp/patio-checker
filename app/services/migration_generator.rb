require 'rake'
require 'time'
require 'erb'
Dir[Config.app_root_path('./models/*.rb')].each {|file| require file }

module StringToSnakeCase
  refine String do
    def to_snake
      self.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .downcase
    end
  end
end

module MigrationGenerator
  AVAILABLE_ACTIONS = %w( create change ).freeze

  using StringToSnakeCase

  class << self
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
      File.join(Config.app_root_path("db/migrate/#{filename(action: action, class_name: class_name)}"))
    end

    def filename(action:, class_name:)
      time = Time.now.strftime("%Y%m%d%H%M%S")
      [time, action, class_name.to_snake].join('_') + '.rb'
    end
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
