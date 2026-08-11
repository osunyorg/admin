# Preview all emails at http://localhost:3000/rails/mailers/extranet_mailer

class ExtranetMailerPreview < BaseMailerPreview

  # Preview this email at http://localhost:3000/rails/mailers/extranet_mailer/invitation_message_automatic
  def invitation_message_automatic
    ExtranetMailer.invitation_message_automatic(extranet, person)
  end

  # Preview this email at http://localhost:3000/rails/mailers/extranet_mailer/invitation_message_manual
  def invitation_message_manual
    ExtranetMailer.invitation_message_manual(invitation)
  end

  protected

  def invitation
    l10n = extranet.best_localization_for(extranet.default_language)
    extranet.invitations.build(
      user: user,
      person: person,
      token: 'sample-invitation-token',
      from_name: user.to_s,
      from_email: user.email,
      to_name: "Invité de test",
      to_email: "guest@noesya.coop",
      message: l10n.invitation_manual_text(
        from_name: user.to_s,
        from_years: '2020',
        to_name: person.to_s
      )
    )
  end

end
