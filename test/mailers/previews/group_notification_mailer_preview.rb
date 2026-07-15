# Preview all emails at http://localhost:3000/rails/mailers/group_notification_mailer

class GroupNotificationMailerPreview < BaseMailerPreview

  # Preview this email at http://localhost:3000/rails/mailers/group_notification_mailer/low_sms_credits
  def low_sms_credits
    user # we will need the user to be created
    credits = 22.0
    GroupNotificationMailer.low_sms_credits(university, credits)
  end
  
  # Preview this email at http://localhost:3000/rails/mailers/group_notification_mailer/new_registration
  def new_registration
    user # we will need the user to be created
    GroupNotificationMailer.new_registration(university, visitor_user)
  end

end
