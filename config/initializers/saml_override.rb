# https://stackoverflow.com/questions/48806629/google-saml-app-not-configured-for-user-equivalent-of-prompt-select-account-sa
module OneLogin
  module RubySaml
    class Authrequest < SamlMessage
      GOOGLE_ACCOUNT_CHOOSER_URL = "https://accounts.google.com/AccountChooser?continue="
      alias_method :old_create, :create
      def create(settings, params = {})
        self.old_create(settings, params)
        @login_url = GOOGLE_ACCOUNT_CHOOSER_URL + CGI.escape(@login_url) if @login_url.starts_with?("https://accounts.google.com")
      end
    end
  end
end