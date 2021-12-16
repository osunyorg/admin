module University::WithResearch
  extend ActiveSupport::Concern

  included do
    has_many :research_journals, class_name: 'Research::Journal', dependent: :destroy
  end
end
