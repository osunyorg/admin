module AsTranslation
  extend ActiveSupport::Concern

  included do
    belongs_to  :language
    belongs_to  :about,
                class_name: "#{self.module_parent.name}"
  end
  
  def original
    @original ||= about.localizations.order(:created_at).first
  end

  def original?
    self == original
  end

end