module AsLocalization
  extend ActiveSupport::Concern

  included do
    belongs_to  :language
    belongs_to  :about,
                class_name: "#{self.module_parent.name}"

    before_validation :set_university
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
end