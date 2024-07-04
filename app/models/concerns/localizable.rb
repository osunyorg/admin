module Localizable
  extend ActiveSupport::Concern

  included do
    attr_accessor :newly_translated

    belongs_to  :language
    belongs_to  :original,
                class_name: base_class.to_s,
                optional: true
    has_many    :localizations,
                foreign_key: :about_id,
                inverse_of: :about,
                dependent: :destroy
    # Deprecated
    has_many    :translations,
                class_name: base_class.to_s,
                foreign_key: :original_id


    accepts_nested_attributes_for :localizations

    before_validation :ensure_translatable_relations_are_in_correct_language

    # has to be before_destroy because of the foreign key constraints
    before_destroy :destroy_or_nullify_translations

    # on cherche les objets pour cette langue (original ou pas) + les objets originaux dans une autre langue s'il n'en existe pas de traduction
    # scope :in_closest_language_id, -> (language_id) {
    #   # Records with correct language (Original or Translation)
    #   # OR Records originals which does not have any translation matching the language
    #   for_language_id(language_id).or(
    #     where(original_id: nil)
    #       .where.not(language_id: language_id)
    #       .where(
    #         "NOT EXISTS (SELECT 1 FROM #{table_name} AS translations WHERE translations.original_id = #{table_name}.id AND translations.language_id = ?)",
    #         language_id
    #       )
    #   )
    # }

    scope :tmp_original, -> { where(original_id: nil) }

    scope :for_language, -> (language) { for_language_id(language.id) }
    # The for_language_id scope can be used when you have the ID without needing to load the Language itself
    scope :for_language_id, -> (language_id) { where(language_id: language_id) }

  end

  def localizable?
    true
  end

  def localization_for(language)
    localizations.find_by(language_id: language.id)
  end

  def original_localization
    @original_localization ||= localizations.order(:created_at).first
  end

  def best_localization_for(language)
    localization_for(language) || original_localization
  end

  def localized_in?(language)
    localization_for(language).present?
  end

  def localize_in!(language)
    l10n = original_localization.dup
    l10n.language = language
    l10n.save
    # TODO gérer les blocs et le reste
  end

  def to_s_in(language)
    best_localization_for(language).to_s
  end

  # This is supposed to be overwritten in model
  # Declare dependencies and their relations with the object
  # [
  #   { relation: :programs, list: programs },
  #   { relation: :author, object: author }
  # ]
  def translatable_relations
    []
  end

  def available_languages
    @available_languages ||= begin
      languages = is_direct_object? ? website.languages : university.languages
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

  def original_language
    @original_language ||= original_object.language
  end

  def is_a_translation?
    self.original.present?
  end

  def is_in_language?(l)
    language.id == l.id
  end

  def exists_in_language?(l)
    translation_for(l).present?
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
    translate_other_attachments(translation)
    # Handle relations (programs, author, schools...)
    translate_relations!(translation)
    translation.save
    # Handle headings & blocks if object has any
    translate_contents!(translation) if respond_to?(:contents)

    translation
  end

  # protected

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

  # can be overwritten in model
  def translate_other_attachments(translation)
  end

  def translate_relations!(translation)
    translatable_relations.each do |hash|
      # Single or multiple: programs, author
      relation_name = hash[:relation]
      # Array of objects or single object
      association = association_in_correct_language(hash, translation.language)
      translation.public_send("#{relation_name}=", association)
    end
  end

  def ensure_translatable_relations_are_in_correct_language
    translate_relations!(self)
  end

  def association_in_correct_language(hash, language)
    if hash.has_key?(:list)
      # association is an array (has_many, habtm, ...)
      hash[:list].map { |object| object.find_or_translate!(language) }
    else
      # association can be an object (has_one, belongs_to)
      hash[:object].find_or_translate!(language) if hash[:object].present?
    end
  end

  # Translatable is included in either Direct or Indirect Objects
  # If object is direct we do not want to remove the translations
  # If object is indirect we remove the translations
  def destroy_or_nullify_translations
    # TODO: remove ?
    # is_direct_object? ? translations.update_all(original_id: nil)
    #                   : translations.destroy_all
  end

end