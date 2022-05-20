class Static
  def self.clean_path(path)
    path += '/' unless path.end_with? '/'
    path.gsub("//", '/')
  end

  def self.render(template_static, about, website)
    string = ApplicationController.render(
      template: template_static,
      layout: false,
      assigns: {
        about: about,
        website: website
      }
    )
    # We don't want &#39; in the frontmatters!
    string.gsub! '&#39\;', "'"
    string
  end
end
