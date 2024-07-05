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

  def localize_in!(language)
    l10n = self.dup
    l10n.language = language

    # Localized should not be published immediately
    l10n.published = false if respond_to?(:published)

    # Handle featured image if object has one, and other attachments
    localize_attachment(l10n, :featured_image) if try(:featured_image)&.attached?
    localize_other_attachments(l10n)

    # Blocks need an about, so we save before translating blocks
    l10n.save

    # Handle headings & blocks if object has any
    localize_contents!(l10n) if respond_to?(:contents)

  end

  protected

  def localize_contents!(localization)
    blocks.without_heading.ordered.each do |block|
      block.translate!(localization)
    end

    headings.root.ordered.each do |heading|
      heading.translate!(localization)
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