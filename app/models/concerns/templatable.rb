module Templatable
  extend ActiveSupport::Concern
  
  included do
    ATTRIBUTES_ALWAYS_EXCLUDED_FROM_TEMPLATE = [
      'id', # The object created is new
      'template_id', # The template has no template, so we should not touch that
      'is_template' # The object created from a template is not a template itself
    ].freeze

    belongs_to :template, class_name: self.name, optional: true

    scope :templates, -> { where(is_template: true) }
    scope :except_templates, -> { where(is_template: false) }
  end

  def has_template?
    template.present?
  end

  def attributes_excluded_from_template
    []
  end

  def manage_template_from_params(params, current_university)
    if params.has_key?(:is_template) 
      self.is_template = true
    elsif params.has_key?(:template_id)
      self.template_id = params[:template_id]
      # Only use templates
      raise "Object with id #{params[:template_id]} is not a template." unless self.template.is_template?
      # Prevent stealing template from another instance
      raise "Object with id #{params[:template_id]} is from a different instance." if self.template.university != current_university
    end
  end

  def apply_template_in(language)
    exclusions = ATTRIBUTES_ALWAYS_EXCLUDED_FROM_TEMPLATE + attributes_excluded_from_template
    self.attributes = template.attributes.except(*exclusions)
    self.localizations = []
    template_l10n = template.localization_for(language)
    l10n = template_l10n.dup
    l10n.about = self
    l10n.slug = nil
    self.localizations << l10n
    l10n
  end

  def create_blocks_from_template(language)
    template_l10n = template.localization_for(language)
    l10n = localization_for(language)
    duplicate_blocks(template_l10n, l10n)
  end
end