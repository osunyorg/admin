module User::WithOmniauth
  extend ActiveSupport::Concern

  included do

    def self.from_omniauth(university, attributes)
      mapping = university.sso_mapping
      email = 'pierreandre.boissinot@noesya.coop'

      # email_sso_key = mapping.select { |elmt| elmt['internal_key'] == 'email' }&.first&.dig('sso_key')
      email_sso_key = 'email'
      email = attributes.dig(email_sso_key)
      return unless email
      email = email.first if email.is_a?(Array)
      email = email.downcase

      user = User.where(university: university, email: email).first_or_create do |u|
        u.password = "#{Devise.friendly_token[0,20]}!" # meets password complexity requirements
      end
      user
    end

  end

end
