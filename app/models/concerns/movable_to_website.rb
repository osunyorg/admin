module MovableToWebsite
  extend ActiveSupport::Concern

  def move_to!(website)
    source_website = self.website
    transaction do
      update(communication_website_id: website.id, university_id: website.university_id)
      clean_categories_after_move
      clean_content_federations_after_move
      move_localizations_to(website)
      after_moved_to_website(source_website, website)
      source_website.clean
    end
    self
  end

  protected

  def clean_categories_after_move
    return unless respond_to?(:categories)
    categories.clear
  end

  def clean_content_federations_after_move
    return unless respond_to?(:content_federations)
    content_federations.destroy_all
  end

  def move_localizations_to(website)
    localizations.each do |l10n|
      l10n.update(communication_website_id: website.id, university_id: website.university_id)
      move_featured_image(l10n, website)
      move_blocks(l10n, website)
    end
  end

  def move_featured_image(l10n, website)
    return unless l10n.respond_to?(:featured_image) && l10n.featured_image.attached?
    return if l10n.featured_image.blob.university_id == website.university_id
    l10n.featured_image.blob.update(university_id: website.university_id)
  end

  def move_blocks(l10n, website)
    return unless l10n.respond_to?(:blocks)
    l10n.blocks.ordered.each do |block|
      block.update(communication_website_id: website.id, university_id: website.university_id)
    end
  end

  def after_moved_to_website(source_website, target_website)
    # Overridable method to implement specific logic
  end

end
