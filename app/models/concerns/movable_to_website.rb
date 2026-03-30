module MovableToWebsite
  extend ActiveSupport::Concern

  # NOTE: this method does not handle move across universities, as we currently don't have any use case for it. 
  # If we need to support it in the future, we will need to update the method to also update the university_id of the object and its associations, and handle potential conflicts (e.g. slug) that may arise from the move.
  def move_to!(website)
    source_website = self.website
    transaction do
      update(communication_website_id: website.id)
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
      l10n.update(communication_website_id: website.id)
      move_blocks(l10n, website)
    end
  end

  def move_blocks(l10n, website)
    return unless l10n.respond_to?(:blocks)
    l10n.blocks.ordered.each do |block|
      block.update(communication_website_id: website.id)
    end
  end

  def after_moved_to_website(source_website, target_website)
    # Overridable method to implement specific logic
  end

end
