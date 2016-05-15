class CreateBoleroPersistedSteps < ActiveRecord::Migration
  def self.up
    create_table :bolero_persisted_steps do |t|
      t.string :session_id
      t.text :persisted_data
      t.text :completed_steps

      t.timestamps null: false
    end
    add_index :bolero_persisted_steps, :session_id
  end

  def self.down
    drop_table :bolero_persisted_steps
  end
end
