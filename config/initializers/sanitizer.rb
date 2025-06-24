Rails.application.configure do
  # TEMP TODO: Corriger le problème des nbsp avec le sanitizer HTML5
  config.action_view.sanitizer_vendor = Rails::HTML4::Sanitizer
  config.action_view.sanitized_allowed_tags = [
    "a", "b", "br", "em", "i", "img", "li", "ol", "p", "q", "strong", "sub", "sup", "ul", "note"
  ]
  config.action_view.sanitized_allowed_attributes = [
    "href", "target", "title"
  ]
end
