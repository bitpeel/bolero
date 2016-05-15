require 'rails/generators/active_record'

class Bolero::InstallGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  argument :name, type: :string, default: 'create_bolero_persisted_steps'
  def install
    migration_template 'migration.rb', "db/migrate/#{name}.rb"
  end
end
