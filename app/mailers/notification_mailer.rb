class NotificationMailer < ApplicationMailer
  helper :application # gives access to all helpers defined within `application_helper`.
  default template_path: 'mailers/notifications'

  def import(import)
    merge_with_university_infos(import.university, {})
    @import = import
    @url = public_send(import.url_pattern, import, { lang: import.language.iso_code })
    I18n.with_locale(import.user.language.iso_code) do
      subject = import.finished_with_errors? ?  t('mailers.notifications.import.subject_with_errors') :
                                                t('mailers.notifications.import.subject_without_errors')
      mail(from: import.university.mail_from[:full], to: import.user.email, subject: subject) if should_send?(import.user.email)
    end
  end

  def emergency_message(emergency_message, user, lang)
    merge_with_university_infos(user.university, {})
    subject = emergency_message.public_send("subject_#{lang}")
    @message = emergency_message.public_send("content_#{lang}")
    I18n.with_locale(user.language.iso_code) do
      mail(from: user.university.mail_from[:full], to: user.email, subject: subject) if should_send?(user.email)
    end
  end

  def website_invalid_access_token(website, user)
    @website = website
    merge_with_university_infos(@website.university, {})
    @url = edit_admin_communication_website_url(@website, lang: @website.default_language.iso_code)
    I18n.with_locale(user.language.iso_code) do
      subject = t('mailers.notifications.website_invalid_access_token.subject', website: website)
      mail(from: user.university.mail_from[:full], to: user.email, subject: subject) if should_send?(user.email)
    end
  end

  def low_sms_credits(university, credits)
    merge_with_university_infos(university, {})
    @credits = credits.to_i
    mails = university.users.server_admin.pluck(:email)
    whitelisted_mails = mails.select { |mail| should_send?(mail) }
    I18n.with_locale(university.default_language.iso_code) do
      subject = t('mailers.notifications.low_sms_credits.subject', credits: @credits)
      mail(from: university.mail_from[:full], to: whitelisted_mails, subject: subject) if whitelisted_mails.any?
    end
  end

  def new_registration(university, user)
    merge_with_university_infos(university, {})
    @user = user
    mails = university.users.where.not(id: @user.id).where(role: [:server_admin, :admin]).pluck(:email)
    whitelisted_mails = mails.select { |mail| should_send?(mail) }
    I18n.with_locale(university.default_language.iso_code) do
      subject = t('mailers.notifications.new_registration.subject', mail: @user.email)
      mail(from: university.mail_from[:full], to: whitelisted_mails, subject: subject) if whitelisted_mails.any?
    end
  end

end
