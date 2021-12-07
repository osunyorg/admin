module Communication::Website::WithPublishableObjects
  extend ActiveSupport::Concern

  included do
    def publish_about_object
      # TODO: Handle Research::Journal then use the commented version.
      # about.force_publish! unless about.nil?
      about.force_publish! if about.is_a?(Education::School)
    end

  end
end
