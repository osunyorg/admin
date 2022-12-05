class Communication::Website::Permalink::Page < Communication::Website::Permalink
  def self.required_for_website?(website)
    false
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  def published_path
    about.path
  end
end
