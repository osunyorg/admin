module Education
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'education_'
  end

  def self.parts
    [
      [University::Person::Teacher, :admin_education_teachers_path],
      [Education::School, :admin_education_schools_path],
      [Education::Diploma, :admin_education_diplomas_path],
      [Education::Program, :admin_education_programs_path],
    ]
  end
end
