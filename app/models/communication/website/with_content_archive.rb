module Communication::Website::WithContentArchive
  extend ActiveSupport::Concern

  def max_archive_datetime
    @max_archive_datetime ||= Time.current - years_before_archive_content.years
  end

  def max_archive_date
    @max_archive_date ||= max_archive_datetime.to_date
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
    event_localizations
      .joins(:about)
      .where.not(communication_website_agenda_events: { is_lasting: true })
      .published
      .where("communication_website_agenda_events.to_day < ?", max_archive_date).each do |event_l10n|
      event_l10n.update(published: false)
    end
  end

  def unpublish_archivable_exhibitions
    exhibition_localizations
      .joins(:about)
      .where.not(communication_website_agenda_exhibitions: { is_lasting: true })
      .published
      .where("communication_website_agenda_exhibitions.to_day < ?", max_archive_date).each do |exhibition_l10n|
      exhibition_l10n.update(published: false)
    end
  end
end
