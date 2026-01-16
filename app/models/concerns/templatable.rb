module Templatable
  extend ActiveSupport::Concern
  
  included do
    belongs_to  :template, 
                class_name: self.name,
                optional: true
    has_many    :generated_objects,
                class_name: self.name,
                foreign_key: :template_id,
                dependent: :nullify

    scope :templates, -> { where(is_template: true) }
    scope :except_templates, -> { where(is_template: false) }

    after_create :create_blocks_from_template_if_necessary
  end

  def has_template?
    template.present?
  end

  # These attributes are used to avoid data copying from template.
  # For example, for an event, the start and end dates should not be inherited.
  def template_attributes_excluded
    []
  end

  def manage_template_from_params(params, current_university)
    if params.has_key?(:is_template)
      self.is_template = true
    elsif params.has_key?(:template_id)
      self.template_id = params[:template_id]
      # Template has to exist
      raise "Object with id #{params[:template_id]} not found"if self.template.nil?
      # Only use templates
      raise "Object with id #{params[:template_id]} is not a template." unless self.template.is_template?
      # Prevent stealing template from another instance
      raise "Object with id #{params[:template_id]} is from a different instance." if self.template.university != current_university
      apply_template_to_object
      apply_template_to_localization
    end
  end

  def apply_template_to_object
    exclusions = [
        'id',           # The object created is new
        'template_id',  # The template has no template, so we should not touch that
        'is_template'   # The object created from a template is not a template itself
        'created_at',   # The creation date is not inherited
        'updated_at',   # The update date is not inherited
        'created_by_id',# The creator is not inherited
      ] + template_attributes_excluded
    self.attributes = template.attributes.except(*exclusions)
  end

  def apply_template_to_localization
    l10n = localizations.first
    template_l10n = template.localization_for(l10n.language)
    exclusions = [
        'id',   # The localization created is new
        'slug'  # The slug will depend on the new title
      ]
    l10n.attributes = template_l10n.attributes.except(*exclusions)
  end

  def create_blocks_from_template_if_necessary
    create_blocks_from_template if has_template?
  end

  def create_blocks_from_template
    l10n = original_localization
    template_l10n = template.localization_for(l10n.language)
    duplicate_blocks(template_l10n, l10n)
  end
end