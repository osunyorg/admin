module User::WithOmniauth
  extend ActiveSupport::Concern

  included do

    def self.from_omniauth(university, attributes)
      mapping = university.sso_mapping || []

      # first step: we find the email (we are supposed to have an email mapping)
      email_sso_key = mapping.detect { |elmt| elmt['internal_key'] == 'email' }&.dig('sso_key')
      email = attributes.dig(email_sso_key)
      return unless email
      email = email.first if email.is_a?(Array)

      user = User.where(university: university, email: email.downcase).first_or_create do |u|
        u.password = "#{Devise.friendly_token[0,20]}!" # meets password complexity requirements
      end

      # update user data according to mapping & infos provided by SSO
      mapping.select { |elmt| elmt['internal_key'] != 'email' }.each do |mapping_element|
        user = self.update_data_for_mapping_element(user, mapping_element, attributes)
      end

      user.save
      user
    end

    protected

    def self.update_data_for_mapping_element(user, mapping_element, attributes)
      sso_key = mapping_element['sso_key']
      return user if attributes[sso_key].nil? # if not provided by sso, just return
      internal_key = mapping_element['internal_key']
      user = self.update_data_for_mapping_element_standard(user, mapping_element, self.get_provided_answer(attributes[sso_key]))
      user
    end

    def self.update_data_for_mapping_element_standard(user, mapping_element, sso_value)
      case mapping_element['internal_key']
      when 'language'
        user = self.set_best_id_for(user, mapping_element['type'], sso_value.first)
      when 'role'
        value = mapping_element['roles'].select { |key, val| val == sso_value.first }.first&.first
        user['role'] = value if value
      else
        user[mapping_element['internal_key']] = sso_value.first
      end
      user
    end

    def self.get_provided_answer(value)
      # SAML send an array (even for a single value) where OAuth2 send a string for single values. We harmonize to always get an array
      value.is_a?(Array) ? value : [value]
    end

    def self.set_best_id_for(user, type, iso)
      element_id = eval(type.classify).find_by(iso_code: iso)&.id
      user["#{type}_id"] = element_id unless element_id.nil?
      user
    end

  end

end
