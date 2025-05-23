class Education::AcademicYear::Localization < ApplicationRecord
  include AsLocalization
  include HasGitFiles
  include Initials
  include Permalinkable
  include WithUniversity

  def git_path(website)
    "#{git_path_content_prefix(website)}academic_years/#{academic_year.year}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/education/academic_years/static"
  end

  def to_s
    "#{about.year}"
  end
end
