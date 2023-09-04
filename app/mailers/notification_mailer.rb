class NotificationMailer < ApplicationMailer
  helper :application # gives access to all helpers defined within `application_helper`.
  default template_path: 'mailers/notifications'

  def import(import)
    merge_with_university_infos(import.university, {})
    I18n.locale = import.user.language.iso_code
    subject = import.finished_with_errors? ? t('mailers.notifications.import.subject_with_errors') :
                                             t('mailers.notifications.import.subject_without_errors')

    @import = import
    @url = send(import.url_pattern, import)
    mail(from: import.university.mail_from[:full], to: import.user.email, subject: subject)
  end

  def emergency_message(emergency_message, user, lang)
    merge_with_university_infos(user.university, {})
    I18n.locale = user.language.iso_code
    subject = emergency_message.public_send("subject_#{lang}")
    @message = emergency_message.public_send("content_#{lang}")
    mail(from: user.university.mail_from[:full], to: user.email, subject: subject)
  end

  def website_invalid_access_token(website, user)
    @website = website
    @url = edit_admin_communication_website_path(website)
    merge_with_university_infos(user.university, {})
    I18n.locale = user.language.iso_code
    subject = t('mailers.notifications.website_invalid_access_token.subject', website: website)
    mail(from: user.university.mail_from[:full], to: user.email, subject: subject)
  end

end
