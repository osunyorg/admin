module User::WithExtranet
  extend ActiveSupport::Concern

  included do
    attr_accessor :extranet_to_validate

    validate :extranet_access, unless: -> { extranet_to_validate.blank? }

    private

    def extranet_access
      # do extranet_to_validate alumni include current email?
      # TODO
      # if extranet_to_validate.registration_contact.present?
      #   errors.add :email, I18n.t('extranet.errors.email_not_allowed_with_contact', contact: extranet_to_validate.registration_contact)
      # else
      #   errors.add :email, I18n.t('extranet.errors.email_not_allowed')
      # end
    end

  end
end
