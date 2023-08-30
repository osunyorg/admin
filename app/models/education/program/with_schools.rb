module Education::Program::WithSchools
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :schools,
                            class_name: 'Education::School',
                            join_table: 'education_programs_schools',
                            foreign_key: :education_program_id,
                            association_foreign_key: :education_school_id
  end
end
