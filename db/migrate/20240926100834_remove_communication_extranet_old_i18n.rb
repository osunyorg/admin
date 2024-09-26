class RemoveCommunicationExtranetOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_extranets, :cookies_policy
    remove_colum :communication_extranets, :home_sentence
    remove_colum :communication_extranets, :name
    remove_colum :communication_extranets, :privacy_policy
    remove_colum :communication_extranets, :registration_contact
    remove_colum :communication_extranets, :sso_button_label
    remove_colum :communication_extranets, :terms

  end
end
