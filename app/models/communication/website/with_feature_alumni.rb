module Communication::Website::WithFeatureAlumni
  extend ActiveSupport::Concern

  def can_have_feature_alumni?
    about_type == Education::School.name || about_type == Education::Program.name
  end

  def alumni
    has_alumni? ? about.alumni : University::Person.none
  end

  def has_alumni?
    about && feature_alumni && about.alumni.any?
  end

  def feature_alumni_dependencies
    return [] unless has_alumni?
    about.alumni
  end
end
