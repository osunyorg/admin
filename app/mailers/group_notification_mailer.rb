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
        bcc: whitelisted_mails,
        subject: subject
      ) if whitelisted_mails.any?
    end
  end

  def new_registration(university, user)
    merge_with_university_infos(university, {})
    @user = user
    I18n.with_locale(university.default_language.iso_code) do
      subject = t('mailers.notifications.new_registration.subject', mail: @user.email)
      mail(
        from: university.mail_from[:full],
        bcc: whitelisted_mails,
        subject: subject
      ) if whitelisted_mails.any?
    end
  end

  protected

  def whitelisted_mails
    @whitelisted_mails ||= users_emails.select { |mail| should_send?(mail) }
  end

  def users_emails
    admin_users = @university.users.where(role: [:server_admin, :admin])
    admin_users = admin_users.where.not(id: @user.id) if @user
    admin_users.pluck(:email)
  end

end