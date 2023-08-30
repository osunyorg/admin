module Education::School::WithPrograms
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :programs,
                            class_name: 'Education::Program',
                            join_table: 'education_programs_schools',
                            foreign_key: :education_school_id,
                            association_foreign_key: :education_program_id

    # Why not programs.published ?
    has_and_belongs_to_many :published_programs,
                            -> { published },
                            class_name: 'Education::Program',
                            join_table: 'education_programs_schools',
                            foreign_key: :education_school_id,
                            association_foreign_key: :education_program_id

    has_many :diplomas, -> { distinct },
             through: :programs,
             source: :diploma
             alias_attribute :education_diplomas, :diplomas

  end

  def has_education_programs?
    published_programs.any?
  end

  def has_education_diplomas?
    diplomas.any?
  end
end
