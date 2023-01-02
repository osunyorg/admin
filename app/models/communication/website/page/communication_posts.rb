class Communication::Website::Page::CommunicationPosts < Communication::Website::Page::Special

  def git_path(website)
    "#{git_path_content_prefix(website)}posts/_index.html"
  end

  def git_dependencies
    [
      website.config_default_permalinks,
      website.categories,
      website.authors.map(&:author),
      website.posts
    ].flatten
  end
end