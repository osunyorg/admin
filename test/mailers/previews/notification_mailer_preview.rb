class NotificationMailerPreview < BaseMailerPreview
  def import
    NotificationMailer.import(organizations_import)
  end

  def emergency_message
    NotificationMailer.emergency_message(sample_emergency_message, user, 'fr')
  end

  def website_invalid_access_token
    NotificationMailer.website_invalid_access_token(website, user)
  end

end
