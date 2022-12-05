class Communication::Website::Permalink::Page < Communication::Website::Permalink

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  # /notre-institut/histoire/
  # Pages are special, there is no substitution and no pattern
  def published_path
    about.path
  end
end
