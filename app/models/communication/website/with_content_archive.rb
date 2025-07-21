module Communication::Website::WithContentArchive
  extend ActiveSupport::Concern

  def max_archive_datetime
    @max_archive_datetime ||= Time.current - years_before_archive_content.years
  end

  protected

  def unpublish_archivable_content
    return unless archive_content?
    [post_localizations, event_localizations, exhibition_localizations].each do |localizations|
      localizations.archivable(max_archive_datetime).find_each do |l10n|
        l10n.update(published: false)
      end
    end
  end
end
