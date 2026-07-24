class GroupNotificationMailer < ApplicationMailer
  helper :application # gives access to all helpers defined within `application_helper`.
  default template_path: 'mailers/group_notifications'

  def low_sms_credits(university, credits)
    merge_with_university_infos(university, {})
    @credits = credits.to_i
    I18n.with_locale(university.default_language.iso_code) do
      subject = t('mailers.notifications.low_sms_credits.subject', credits: @credits)
      mail(
        from: university.mail_from[:full],
        bcc: server_admin_emails,
        subject: subject
      ) if server_admin_emails.any?
    end
  end

  def new_registration(university, user)
    merge_with_university_infos(university, {})
    @user = user
    I18n.with_locale(university.default_language.iso_code) do
      subject = t('mailers.notifications.new_registration.subject', mail: @user.email)
      mail(
        from: university.mail_from[:full],
        bcc: server_admin_emails,
        subject: subject
      ) if server_admin_emails.any?
    end
  end

  protected

  def server_admin_emails
    @university.users
               .where(role: [:server_admin])
               .pluck(:email)
  end

end