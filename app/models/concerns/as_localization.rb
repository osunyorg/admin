module AsLocalization
  extend ActiveSupport::Concern

  include LibreTranslatable

  included do
    belongs_to  :language
    belongs_to  :about,
                class_name: "#{self.module_parent.name}",
                touch: true # FIXME twice on nested form

    validates :language_id, uniqueness: { scope: :about_id }

    before_validation :set_university_and_website_from_about

    scope :in_languages, -> (language_ids) {
      where(language_id: language_ids)
    }
  end

  def for_website?(website)
    if is_direct_object?
      self.communication_website_id == website.id
    else
      website.active_language_ids.include?(language_id) &&
      website.has_connected_object?(self)
    end
  end

  # Used by Hugo to link localizations with themselves
  # communication-website-post-25bf629a-27ef-40b6-bb61-4fd0a984e08d
  def static_localization_key
    "#{about.class.polymorphic_name.parameterize}-#{self.about_id}"
  end

  def original
    @original ||= about.localizations.order(:created_at).first
  end

  # If we're creating an object, there is no original yet, but it will be original.
  # Otherwise, comparison is ok.
  def original?
    original.nil? || (self == original)
  end

  def localize_in!(language)
    l10n = self.dup
    l10n.language = language

    # Localized should not be published immediately
    l10n.published = false if respond_to?(:published)

    # Handle featured image if object has one, and other attachments
    localize_attachment(l10n, :featured_image) if try(:featured_image)&.attached?
    localize_other_attachments(l10n)

    # Blocks need an about, so we save before localizing blocks
    l10n.save

    # Handle blocks if object has any
    localize_contents!(l10n) if respond_to?(:contents)
    l10n
  end

  # standalone-category
  # parent-category/child-category
  def slug_with_ancestors_slugs
    slugs = about.ancestors_and_self.map do |ancestor|
      ancestor.best_localization_for(language).slug
    end
    slugs.compact_blank.join('/')
  end

  protected

  def localize_contents!(localization)
    blocks.ordered.each do |block|
      block.localize_for!(localization)
    end
  end

  # Utility method to duplicate attachments
  def localize_attachment(localization, attachment_name)
    from = public_send(attachment_name)
    to = localization.public_send(attachment_name)
    ActiveStorage::Utils.duplicate(from, to)
  end

  # can be overwritten in model
  def localize_other_attachments(localization)
  end

  def set_university_and_website_from_about
    self.university_id = about.university_id
    return unless respond_to? :communication_website_id
    self.communication_website_id = about.communication_website_id
  end

end