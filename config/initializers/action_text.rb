Rails.configuration.to_prepare do
  ActionText::RichText.class_eval do
    delegate :university, :university_id, to: :record
  end

  ActionText::ContentHelper.allowed_tags += Rails.application.config.action_view.sanitized_allowed_tags
  ActionText::ContentHelper.allowed_attributes += Rails.application.config.action_view.sanitized_allowed_attributes
end
