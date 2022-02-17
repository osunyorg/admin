class Communication::Website::IndexPage::EducationPrograms < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::EducationPrograms'
  end

  def git_path(website)
    'content/programs/_index.html'
  end

  def url
    "/#{path}/"
  end

  def git_dependencies(website)
    [self] + active_storage_blobs + website.about.programs
  end

end
