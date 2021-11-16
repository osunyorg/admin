module University::WithEducation
  extend ActiveSupport::Concern

  included do
    has_many :teachers, class_name: 'Education::Teacher', dependent: :destroy
    has_many :education_programs, class_name: 'Education::Program', dependent: :destroy
    has_many :education_schools, class_name: 'Education::School', dependent: :destroy
  end
end
