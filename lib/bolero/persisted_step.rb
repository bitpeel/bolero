class Bolero::PersistedStep < ActiveRecord::Base
  self.table_name = 'bolero_persisted_steps'

  serialize :persisted_data, JSON
end
