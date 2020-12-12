require Config.app_root_path('./services/migration_generator.rb')

namespace :generate do
  desc 'generate migration file'
  task :migration, ['action', 'class_name'] => :environment do |task, args|
    MigrationGenerator.create_migration_file(action: args['action'], class_name: args['class_name'])
  end
end
