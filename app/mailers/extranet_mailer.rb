class ExtranetMailer < ApplicationMailer
  helper :application # Gives access to all helpers defined within `application_helper`
  default template_path: 'mailers/extranet'

  def invitation_message_automatic(extranet, person)
    @extranet = extranet
    @university = @extranet.university
    @person = person
    @language = @user.try(:language) || @university.default_language
    @l10n = @extranet.localization_for(@language)
    @user = @person.user
    # If the person has a user, we use the user's email in priority as it can be used for login
    @email = @user.try(:email) || @person.email

    merge_with_university_infos(@university, {})

    I18n.with_locale(@language.iso_code.to_sym) do
      mail  from: @university.mail_from[:full],
            to: @email,
            subject: @l10n.invitation_message_automatic_subject if should_send?(@email)
    end
  end

  def invitation_message_manual(invitation)
    @invitation = invitation
    extranet = @invitation.extranet
    @university = extranet.university
    language = @invitation.person&.user&.language || @university.default_language
    extranet_l10n = extranet.best_localization_for(language)
    @signature = extranet_l10n.invitation_message_manual_signature
    @registration_url = new_user_registration_url(
      host: extranet.host,
      invitation_token: @invitation.token
    )

    merge_with_university_infos(@university, {})

    I18n.with_locale(language.iso_code.to_sym) do
      mail  from: @university.mail_from[:full],
            to: @invitation.to_email,
            subject: invitation_manual_subject(extranet_l10n) if should_send?(@invitation.to_email)
    end
  end

  private

  def invitation_manual_subject(extranet_l10n)
    extranet_l10n.invitation_manual_subject(
      from_name: @invitation.from_name,
      from_years: @invitation.user.person&.diploma_years_sentence,
      to_name: @invitation.to_name
    )
  end


end
