class AddManualInvitationMessageInfosToExtranets < ActiveRecord::Migration[8.1]
  def change
    rename_column :communication_extranet_localizations, :invitation_message_subject, :invitation_message_automatic_subject
    rename_column :communication_extranet_localizations, :invitation_message_text, :invitation_message_automatic_text
    add_column :communication_extranet_localizations, :invitation_message_manual_subject, :string
    add_column :communication_extranet_localizations, :invitation_message_manual_text, :text
    add_column :communication_extranet_localizations, :invitation_message_manual_signature, :text
  end
end
