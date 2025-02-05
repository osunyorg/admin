class AddInvitationMessageToCommunicationExtranetLocalizations < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_extranet_localizations, :invitation_message_subject, :string, default: ''
    add_column :communication_extranet_localizations, :invitation_message_text, :text, default: ''
  end
end
