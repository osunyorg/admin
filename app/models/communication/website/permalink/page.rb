class Communication::Website::Permalink::Page < Communication::Website::Permalink

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  # Pages are special, there is no substitution
  def published_path
    about.path
  end
end
