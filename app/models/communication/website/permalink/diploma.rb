class Communication::Website::Permalink::Diploma < Communication::Website::Permalink
  def self.required_for_website?(website)
    website.has_education_diplomas?
  end

  def self.static_config_key
    :diplomas
  end

  def self.pattern_in_website(website)
    "#{website.special_page(:education_diplomas).path_without_language}:slug/"
  end
end
