module University::WithEducation
  extend ActiveSupport::Concern

  included do
    has_many  :education_diplomas,
              class_name: 'Education::Diploma',
              dependent: :destroy
    alias_method :diplomas, :education_diplomas

    has_many  :education_programs,
              class_name: 'Education::Program',
              dependent: :destroy
    alias_method :programs, :education_programs

    has_many  :education_program_categories,
              class_name: 'Education::Program::Category',
              dependent: :destroy
    alias_method :program_categories, :education_program_categories

    has_many  :education_schools,
              class_name: 'Education::School',
              dependent: :destroy
    alias_method :schools, :education_schools
  end
end
