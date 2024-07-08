module Localizable
  extend ActiveSupport::Concern

  included do
    # Depracted ?
    attr_accessor :newly_translated

    has_many    :localizations,
                foreign_key: :about_id,
                inverse_of: :about,
                dependent: :destroy

    # Deprecated
    belongs_to  :language,
                optional: true
    belongs_to  :original,
                class_name: base_class.to_s,
                optional: true
    has_many    :translations,
                class_name: base_class.to_s,
                foreign_key: :original_id
    # /Deprecated

    accepts_nested_attributes_for :localizations

    # TODO L10N : remove
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

    # TODO L10N : remove after data cleanup
    scope :tmp_original, -> { where(original_id: nil) }

    scope :for_language, -> (language) { for_language_id(language.id) }
    # The for_language_id scope can be used when you have the ID without needing to load the Language itself
    scope :for_language_id, -> (language_id) {
      # We get the table name of the localizations association to filter the language correctly
      localizations_table_name = _reflect_on_association(:localizations).klass.table_name
      joins(:localizations).where(localizations_table_name => { language_id: language_id })
    }

  end

  def localizable?
    true
  end

  def available_languages
    @available_languages ||= begin
      languages = is_direct_object? ? website.languages : university.languages
      languages.ordered
    end
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

  def localize_in!(language)
    original_localization.localize_in!(language)
  end

  def exists_in_language?(l)
    localization_for(l).present?
  end
  alias :localized_in? :exists_in_language?

  def published_in?(language)
    localization_for(language).try(:published?)
  end

  def to_s_in(language)
    best_localization_for(language).to_s
  end

  ### DEPRECATED METHODS - has to be removed when cleaning L10N

  # This is supposed to be overwritten in model
  # Declare dependencies and their relations with the object
  # [
  #   { relation: :programs, list: programs },
  #   { relation: :author, object: author }
  # ]
  def translatable_relations
    []
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

  # deprecated for localize_in(language)
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


  # deprecated
  def translate_parent!(language)
    return nil if parent_id.nil?
    parent.find_or_translate!(language)
  end

  # deprecated
  def translate_contents!(translation)
    blocks.without_heading.ordered.each do |block|
      block.translate!(translation)
    end

    headings.root.ordered.each do |heading|
      heading.translate!(translation)
    end
  end

  # deprecated
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

  # deprecated
  # can be overwritten in model
  def translate_other_attachments(translation)
  end

  # deprecated
  def translate_relations!(translation)
    translatable_relations.each do |hash|
      # Single or multiple: programs, author
      relation_name = hash[:relation]
      # Array of objects or single object
      association = association_in_correct_language(hash, translation.language)
      translation.public_send("#{relation_name}=", association)
    end
  end

  # deprecated
  def ensure_translatable_relations_are_in_correct_language
    translate_relations!(self)
  end

  # deprecated
  def association_in_correct_language(hash, language)
    if hash.has_key?(:list)
      # association is an array (has_many, habtm, ...)
      hash[:list].map { |object| object.find_or_translate!(language) }
    else
      # association can be an object (has_one, belongs_to)
      hash[:object].find_or_translate!(language) if hash[:object].present?
    end
  end


end