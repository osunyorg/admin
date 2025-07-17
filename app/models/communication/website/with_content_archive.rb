module Communication::Website::WithContentArchive
  extend ActiveSupport::Concern

  def max_archive_datetime
    Time.current - years_before_archive_content.years
  end

  protected

  def unpublish_archivable_content
    return unless archive_content?
    unpublish_archivable_posts
    unpublish_archivable_events
    unpublish_archivable_exhibitions
  end

  def unpublish_archivable_posts
    post_localizations
      .joins(:about)
      .where.not(communication_website_posts: { is_lasting: true })
      .published
      .where("published_at <= ?", max_archive_datetime).each do |post_l10n|
      post_l10n.update(published: false)
    end
  end

  def unpublish_archivable_events
    # Dépublier les événements (non pérennes) terminés il y a plus de X ans
  end

  def unpublish_archivable_exhibitions
    # Dépublier les expositions (non pérennes) terminées il y a plus de X ans
  end
end
