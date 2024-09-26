class RemoveCommunicationExtranetOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_extranets, :cookies_policy
    remove_column :communication_extranets, :home_sentence
    remove_column :communication_extranets, :name
    remove_column :communication_extranets, :privacy_policy
    remove_column :communication_extranets, :registration_contact
    remove_column :communication_extranets, :sso_button_label
    remove_column :communication_extranets, :terms

  end
end
