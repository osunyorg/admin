module Communication::Website::Agenda::Period::BasePeriod
  extend ActiveSupport::Concern

  included do
    after_save :create_all_localizations
    after_touch :create_all_localizations
    after_touch :touch_localizations

    scope :ordered, -> { order(:value) }
    default_scope { ordered }
  end

  # Just for debugging
  def to_s
    "#{value}"
  end

  protected

  def create_all_localizations
    available_languages.each do |language|
      localizations.where(
        university: university,
        website: website,
        language: language
      ).first_or_create
    end
  end

  def touch_localizations
    localizations.each(&:touch)
  end
end