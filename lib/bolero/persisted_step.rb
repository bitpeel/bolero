class Bolero::PersistedStep < ActiveRecord::Base
  self.table_name = 'bolero_persisted_steps'

  serialize :persisted_data, JSON
  serialize :completed_steps, JSON

  def expired?
    return false unless updated_at
    updated_at < 2.hours.ago
  end
end
