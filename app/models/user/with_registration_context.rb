module User::WithRegistrationContext
  extend ActiveSupport::Concern

  included do
    attr_accessor :registration_context

    validate :extranet_access, on: :create, if: -> { registration_context.is_a?(Communication::Extranet) }

    private

    def extranet_access
      unless user_can_access_registration_context?
        if registration_context.registration_contact.present?
          errors.add :email, I18n.t('extranet.errors.email_not_allowed_with_contact', contact: registration_context.registration_contact)
        else
          errors.add :email, I18n.t('extranet.errors.email_not_allowed')
        end
      end
    end

    def user_can_access_registration_context?
      (registration_context.has_feature?(:alumni) && registration_context.alumni.where(email: email).any?) ||
        (registration_context.has_feature?(:contacts) && registration_context.connected_persons.where(email: email).any?)
    end

  end
end
