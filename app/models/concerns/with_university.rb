module WithUniversity
  extend ActiveSupport::Concern

  included do
    belongs_to :university
    validates :university, presence: true

    scope :in_university, -> (university) { where(university: university) }
  end
end
