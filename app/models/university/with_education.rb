module University::WithEducation
  extend ActiveSupport::Concern

  included do
    has_many :education_programs, class_name: 'Education::Program', dependent: :destroy
  end
end
