class ExtranetMailer < ApplicationMailer
  helper :application # Gives access to all helpers defined within `application_helper`
  default template_path: 'mailers/extranet'

  def invitation_message(extranet, person)
    @extranet = extranet
    @university = @extranet.university
    @person = person
    @language = @user.try(:language) || @university.default_language
    @l10n = @extranet.localization_for(@language)
    @user = @person.user
    # If the person has a user, we use the user's email in priority as it can be used for login
    @email = @user.try(:email) || @person.email

    merge_with_university_infos(@university, {})

    mail  from: @university.mail_from[:full],
          to: @email,
          subject: @l10n.invitation_message_subject if should_send?(@email)
  end

end
