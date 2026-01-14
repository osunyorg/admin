module Templatable
  extend ActiveSupport::Concern
  
  included do
    belongs_to :template, class_name: self.name, optional: true

    scope :templates, -> { where(is_template: true) }
    scope :except_templates, -> { where(is_template: false) }
  end

  def use_template(template, current_language)
    self.attributes = template.attributes.except('id')
    self.template = template
    self.is_template = false
    self.localizations = []
    current_l10n = nil
    template.localizations.each do |template_l10n|
      l10n = template_l10n.dup
      l10n.about = self
      l10n.slug = nil
      current_l10n = l10n if l10n.language == current_language
      self.localizations << l10n
    end
    current_l10n
  end
end