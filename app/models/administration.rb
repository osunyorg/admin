module Administration
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'administration_'
  end

  def self.parts
    [
      [University::Person::Alumnus, :admin_administration_alumni_path],
      [Administration::Cohort, :admin_administration_cohorts_path],
      [Administration::Location, :admin_administration_locations_path],
      [Administration::AcademicYear, :admin_administration_academic_years_path],
      [Administration::Qualiopi, :admin_administration_qualiopi_criterions_path],
    ]
  end
end
