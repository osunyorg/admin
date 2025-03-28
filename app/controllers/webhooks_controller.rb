class WebhooksController < ApplicationController
  skip_before_action  :verify_authenticity_token, :authenticate_user!

  def brevo
    # Sendinblue IP range : 185.107.232.0/24
    redirect_to root_path and return unless ENV['APPLICATION_ENV'] == 'development' || request.remote_ip.start_with?('1.179')

    email = params['email']
    if ['unsubscribe', 'unsubscribed'].include?(params['event'])
      User.where(email: email).find_each { |user|
        user.update(optin_newsletter: false, from_brevo_webhook: true)
      }
    end

    head :ok
  end

end
