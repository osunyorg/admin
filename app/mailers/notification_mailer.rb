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

end
