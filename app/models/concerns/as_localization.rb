module AsLocalization
  extend ActiveSupport::Concern

  include AsIndirectObject
  include LibreTranslatable

  included do
    belongs_to  :language
    belongs_to  :about,
                class_name: "#{self.module_parent.name}",
                touch: true # FIXME twice on nested form

    validates :language_id, uniqueness: { scope: :about_id }

    before_validation :set_university

    # delegate :websites, to: :about

    scope :in_languages, -> (language_ids) {
      where(language_id: language_ids)
    }
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

  def should_sync_to?(website)
    website.active_language_ids.include?(language_id) &&
    website.has_connected_object?(self)
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
    about.ancestors_and_self.map { |ancestor| 
      l10n = ancestor.localization_for(language)
      if l10n.nil? || l10n.try(:draft?)
        # If l10n is nil or draft, no slug
        nil
      else
        # otherwise (published or no publication state) we return the slug
        l10n.slug
      end
    }.compact_blank.join('/')
  end

  protected

  def set_university
    self.university_id = about.university_id
  end

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
end
