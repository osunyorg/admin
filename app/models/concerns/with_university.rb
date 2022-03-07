module WithUniversity
  extend ActiveSupport::Concern

  included do
    belongs_to :university
    validates_presence_of :university
  end
end
