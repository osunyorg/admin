class Communication::Website::Page::Home < Communication::Website::Page::Special  
  def git_path(website)
    "#{git_path_content_prefix(website)}_index.html"
  end

  protected 

  def set_slug
    self.slug = ''
  end
end