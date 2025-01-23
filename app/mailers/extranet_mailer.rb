class ExtranetMailer < ApplicationMailer
  helper :application # gives access to all helpers defined within `application_helper`.
  default template_path: 'mailers/extranet'

  def invitation_message(extranet, person)
    @extranet = extranet
    @person = person
    university = @extranet.university
    merge_with_university_infos(university, {})

    @user = @person.user
    # If the person has a user, we use the user's email in priority as it can be used for login.
    @email = @user.present? ? @user.email : @person.email
    language = @user.present? ? @user.language : university.default_language
    @extranet_name = @extranet.to_s_in(language)

    I18n.with_locale(language.iso_code) do
      subject = t('mailers.extranet.invitation_message.subject', extranet: @extranet_name)
      mail(from: university.mail_from[:full], to: @email, subject: subject) if should_send?(@email)
    end
  end

end
