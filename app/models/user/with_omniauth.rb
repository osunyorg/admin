module User::WithOmniauth
  extend ActiveSupport::Concern

  included do

    def self.from_omniauth(university, attributes)
      mapping = university.sso_mapping
      email = 'pierreandre.boissinot@noesya.coop'

      user = User.where(university: university, email: email).first_or_create do |u|
        u.password = "#{Devise.friendly_token[0,20]}!" # meets password complexity requirements
      end
      user
    end

  end

end
