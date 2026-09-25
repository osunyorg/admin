class Communication::Website::Page::CommunicationFile < Communication::Website::Page

  def is_hugo_index?
    true
  end

  def dependencies
    super +
    [website.config_default_languages]
  end

  def references
    website.connected_communication_files
  end

  def git_path_relative
    'files/_index.html'
  end

  def special_page_categories
    university.communication_file_categories
  end

  def hugo_body_class
    'files__section'
  end
end
