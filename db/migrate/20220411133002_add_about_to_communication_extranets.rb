class AddAboutToCommunicationExtranets < ActiveRecord::Migration[6.1]
  def change
    add_reference :communication_extranets, :about, polymorphic: true, type: :uuid

  end
end
