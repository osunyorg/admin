# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer

class NotificationMailerPreview < BaseMailerPreview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/import
  def import
    NotificationMailer.import(organizations_import)
  end
  
  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/emergency_message
  def emergency_message
    NotificationMailer.emergency_message(sample_emergency_message, user, 'fr')
  end
  
  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/website_invalid_access_token
  def website_invalid_access_token
    NotificationMailer.website_invalid_access_token(website, user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/low_sms_credits
  def low_sms_credits
    user # we will need the user to be created
    credits = 22.0
    NotificationMailer.low_sms_credits(university, credits)
  end
  
  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/new_registration
  def new_registration
    user # we will need the user to be created
    NotificationMailer.new_registration(university, visitor_user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/gdpr_deletion_incoming
  def gdpr_deletion_incoming
    NotificationMailer.gdpr_deletion_incoming(university, visitor_user)
  end


end
