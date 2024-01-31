module University::WithResearch
  extend ActiveSupport::Concern

  included do
    has_many :research_journals, class_name: 'Research::Journal', dependent: :destroy
    has_many :research_laboratories, class_name: 'Research::Laboratory', dependent: :destroy
    has_many :research_theses, class_name: 'Research::Thesis', dependent: :destroy
  end
end
