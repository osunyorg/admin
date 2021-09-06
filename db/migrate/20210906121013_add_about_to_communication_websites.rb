class AddAboutToCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    add_reference :communication_websites, :about, polymorphic: true, null: true, type: :uuid
  end
end
