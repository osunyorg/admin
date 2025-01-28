# Preview all emails at http://localhost:3000/rails/mailers/extranet_mailer

class ExtranetMailerPreview < BaseMailerPreview

  # Preview this email at http://localhost:3000/rails/mailers/extranet_mailer/invitation_message
  def invitation_message
    ExtranetMailer.invitation_message(extranet, person)
  end

end
