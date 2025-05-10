class WebhooksController < ApplicationController
  skip_before_action  :verify_authenticity_token, :authenticate_user!

  def brevo
    # Brevo IP range for webhooks : 1.179.112.0/20
    redirect_to root_path and return unless ENV['APPLICATION_ENV'] == 'development' || IPAddr.new("1.179.112.0/20").include?(request.remote_ip)

    email = params['email']
    if ['unsubscribe', 'unsubscribed'].include?(params['event'])
      User.where(email: email).find_each { |user|
        user.update(optin_newsletter: false, from_brevo_webhook: true)
      }
    end

    head :ok
  end

end
