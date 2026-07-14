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

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/website_git_access_broken
  def website_git_access_broken
    error = Git::Providers::Github::RepositoryForbidden.new("Token does not have push access to #{website.repository}")
    NotificationMailer.website_git_access_broken(website, user, website.git_access_error_message(error))
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/gdpr_deletion_incoming
  def gdpr_deletion_incoming
    NotificationMailer.gdpr_deletion_incoming(university, visitor_user)
  end

end