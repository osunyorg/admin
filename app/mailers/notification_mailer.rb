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
    merge_with_university_infos(@website.university, {})
    @url = edit_admin_communication_website_url(@website)
    I18n.locale = user.language.iso_code
    subject = t('mailers.notifications.website_invalid_access_token.subject', website: website)
    mail(from: user.university.mail_from[:full], to: user.email, subject: subject)
  end
  
  def low_sms_credits(university, credits)
    merge_with_university_infos(university, {})
    @credits = credits.to_i
    mails = university.users.server_admin.pluck(:email)
    I18n.locale = university.default_language.iso_code
    subject = t('mailers.notifications.low_sms_credits.subject', credits: @credits)
    mail(from: university.mail_from[:full], to: mails, subject: subject)
  end
  
  def new_registration(university, user)
    merge_with_university_infos(university, {})
    @user = user
    mails = university.users.where.not(id: @user.id).where(role: [:server_admin, :admin]).pluck(:email)
    I18n.locale = university.default_language.iso_code
    subject = t('mailers.notifications.new_registration.subject', mail: @user.email)
    mail(from: university.mail_from[:full], to: mails, subject: subject)
  end

end
