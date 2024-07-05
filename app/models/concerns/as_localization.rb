module AsLocalization
  extend ActiveSupport::Concern

  included do
    include WithDependencies

    belongs_to  :language
    belongs_to  :about,
                class_name: "#{self.module_parent.name}"

    before_validation :set_university
  end

  # Used by Hugo to link translations with themselves
  def static_translation_key
    "#{self.class.polymorphic_name.parameterize}-#{self.about_id}"
  end

  def original
    @original ||= about.localizations.order(:created_at).first
  end

  def original?
    self == original
  end

  def set_university
    self.university_id = about.university_id
  end

  def for_website?(website)
    website.language_ids.include?(language_id) &&
    about.for_website?(website)
  end
end