class NotificationMailerPreview < ActionMailer::Preview
  def import
    NotificationMailer.import(Import.last)
  end

  # def emergency_message
  #   NotificationMailer.emergency_message(EmergencyMessage.last, User.last, 'fr')
  # end

  # def website_invalid_access_token
  #   NotificationMailer.website_invalid_access_token(Communication::Website.last, User.last)
  # end

end
