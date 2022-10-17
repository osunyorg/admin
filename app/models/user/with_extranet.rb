module User::WithExtranet
  extend ActiveSupport::Concern

  included do
    attr_accessor :extranet_to_validate

    validate :extranet_access, unless: -> { extranet_to_validate.blank? }

    private

    def extranet_access
      # do extranet_to_validate alumni include current email?
      # TODO
      # errors.add :email, 'n est pas autorisé'
    end

  end
end
