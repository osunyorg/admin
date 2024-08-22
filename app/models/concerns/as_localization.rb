module AsLocalization
  extend ActiveSupport::Concern

  included do
    include WithDependencies
    include LibreTranslatable

    belongs_to  :language
    belongs_to  :about,
                class_name: "#{self.module_parent.name}",
                touch: true # FIXME twice on nested form

    validates :language_id, uniqueness: { scope: :about_id }

    before_validation :set_university

    scope :in_languages, -> (language_ids) {
      where(language_id: language_ids)
    }

    delegate  :is_direct_object?,
              :is_indirect_object?,
              to: :about
  end

  def delete_obsolete_connections
    about.try(:delete_obsolete_connections)
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

  # TODO L10N : To handle
  # Used to fix Dependencies::CleanWebsitesIfNecessaryJob on Organization::Localization
  def websites
    if about.respond_to?(:websites)
      about.websites
    else
      raise NameError, "No method 'websites' for #{about.class}"
    end
  end

  # TODO L10N : To handle
  # Used to fix Communication::Website::IndirectObject::SyncWithGitJob on Communication::Block
  def direct_sources_from_existing_connections
    if about.respond_to?(:direct_sources_from_existing_connections)
      about.direct_sources_from_existing_connections
    else
      raise NameError, "No method 'direct_sources_from_existing_connections' for #{about.class}"
    end
  end

  def for_website?(website)
    website.active_language_ids.include?(language_id) &&
      about.for_website?(website)
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

    # Handle headings & blocks if object has any
    localize_contents!(l10n) if respond_to?(:contents)

  end

  # standalone-category
  # parent-category/child-category
  def slug_with_ancestors_slugs(separator: '/')
    slugs = about.ancestors_and_self.map do |ancestor|
      ancestor.best_localization_for(language).slug
    end
    slugs.compact_blank.join(separator)
  end

  protected

  def set_university
    self.university_id = about.university_id
  end

  def localize_contents!(localization)
    blocks.without_heading.ordered.each do |block|
      block.localize_for!(localization)
    end

    headings.root.ordered.each do |heading|
      heading.localize_for!(localization)
    end
  end

  # Utility method to duplicate attachments
  def localize_attachment(localization, attachment_name)
    localization.public_send(attachment_name).attach(
      io: URI.open(public_send(attachment_name).url),
      filename: public_send(attachment_name).filename.to_s,
      content_type: public_send(attachment_name).content_type
    )
  rescue
    # Missing attachment
  end

  # can be overwritten in model
  def localize_other_attachments(localization)
  end
end