module WithTranslations
  extend ActiveSupport::Concern

  included do
    attr_accessor :newly_translated

    belongs_to  :language
    belongs_to  :original, class_name: base_class.to_s, optional: true
    has_many    :translations, class_name: base_class.to_s, foreign_key: :original_id, dependent: :nullify

    scope :for_language, -> (language) { for_language_id(language.id) }
    # The for_language_id scope can be used when you have the ID without needing to load the Language itself
    scope :for_language_id, -> (language_id) { where(language_id: language_id) }

  end

  def available_languages
    @available_languages ||= begin
      languages = is_direct_object? ? website.languages : Language.all
      languages.ordered
    end
  end

  def find_or_translate!(language)
    translation = translation_for(language)
    translation ||= translate!(language)
    translation
  end

  def translation_for(language)
    # If the requested language is the object language, we return itself
    return self if language_id == language.id
    # All translations share the same original.
    # If the current object is a translation, we call translation_for on the original.
    # Else, if the current object is the original, we search the translation with the language.
    original_id.present?  ? original.translation_for(language)
                          : translations.find_by(language_id: language.id)
  end

  def original_object
    @original_object ||= (self.original || self)
  end

  def original_with_translations
    original_object.translations + [original_object]
  end

  # Used by Hugo to link translations with themselves
  def static_translation_key
    "#{self.class.polymorphic_name.parameterize}-#{self.original_object.id}"
  end

  def translate!(language)
    translation = self.dup

    # Inherits from original_id or set it to itself
    translation.assign_attributes(
      original_id: original_object.id,
      language_id: language.id,
      newly_translated: true
    )

    # Handle publication
    translation.published = false if respond_to?(:published)
    # Translate parent if needed
    translation.parent_id = translate_parent!(language)&.id if respond_to?(:parent_id)
    # Handle featured image if object has one
    translate_attachment(translation, :featured_image) if respond_to?(:featured_image) && featured_image.attached?
    translation.save
    # Handle headings blocks if object has any
    translate_contents!(translation) if respond_to?(:contents)
    translate_additional_data!(translation)

    translation
  end

  protected

  def translate_parent!(language)
    return nil if parent_id.nil?
    parent.find_or_translate!(language)
  end

  def translate_contents!(translation)
    blocks.without_heading.ordered.each do |block|
      block.translate!(translation)
    end

    headings.root.ordered.each do |heading|
      heading.translate!(translation)
    end
  end

  # Utility method to duplicate attachments
  def translate_attachment(translation, attachment_name)
    translation.public_send(attachment_name).attach(
      io: URI.open(public_send(attachment_name).url),
      filename: public_send(attachment_name).filename.to_s,
      content_type: public_send(attachment_name).content_type
    )
  rescue
    # Missing attachment
  end

  def translate_additional_data!(translation)
    # Overridable method to handle custom cases
  end
end