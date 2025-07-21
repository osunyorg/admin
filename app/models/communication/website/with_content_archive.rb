module Communication::Website::WithContentArchive
  extend ActiveSupport::Concern

  included do
    ARCHIVABLE_MODEL_NAMES = [
      'Communication::Website::Post::Localization',
      'Communication::Website::Agenda::Event::Localization',
      'Communication::Website::Agenda::Exhibition::Localization'
    ].freeze
  end

  def max_archive_datetime
    @max_archive_datetime ||= Time.current - years_before_archive_content.years
  end

  protected

  def unpublish_archivable_content
    return unless archive_content?
    ARCHIVABLE_MODEL_NAMES.each do |model_name|
      unpublish_archivable_model(model_name)
    end
  end

  def unpublish_archivable_model(model_name)
    model = model_name.safe_constantize
    return unless model
    model.where(communication_website_id: id).archivable(max_archive_datetime).find_each do |l10n|
      l10n.update(published: false)
    end
  end
end
