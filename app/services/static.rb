class Static
  def self.clean_path(path)
    path += '/' unless path.end_with? '/'
    path.gsub("//", '/')
  end

  def self.remove_trailing_slash(string)
    string = string[0..-2] if string.end_with?('/')
    string
  end

  def self.has_content?(html)
    !blank?(html)
  end

  def self.blank?(html)
    text = ActionController::Base.helpers.strip_tags html
    text = text.to_s.strip
    text.blank?
  end

  def self.render(template_static, about, website)
    code = ApplicationController.render(
      template: template_static,
      layout: false,
      assigns: {
        about: about,
        website: website
      }
    )
    # We don't want &#39; in the frontmatters!
    code = code.gsub "&#39\;", "'"
    code
  end
end
