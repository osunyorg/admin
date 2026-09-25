class AddSynchronizationLockedByToCommunicationWebsites < ActiveRecord::Migration[8.1]
  def change
    add_reference :communication_websites,
                  :synchronization_locked_by,
                  type: :uuid,
                  foreign_key: {
                    to_table: :users,
                    on_delete: :nullify
                  }
  end
end
