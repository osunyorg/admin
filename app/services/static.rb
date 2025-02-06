class Static
  DOOMED_CHARACTERS = [
    "\u2028", # https://github.com/noesya/pixelis-rapportglobal2023/issues/1
    "\u0094",
    "\u008d", # https://github.com/osunyorg/lacriee-site/actions/runs/9242403369
    "\u009D",
    "\u0090", # https://github.com/osunyorg/marionrebier-beelearning/actions/runs/11340775264
  ]
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
        # In most cases, about is a localization
        about: about,
        # Used to clarify the views
        l10n: about,
        website: website
      }
    )
    code = remove_problematic_characters(code)
    code
  end

  protected

  def self.remove_problematic_characters(code)
    # We don't want &#39; in the frontmatters!
    code = code.gsub("&#39\;", "'")
    # We don't want &amp: either
    code = code.gsub('&amp;', '&')
    # /u0092 breaks everything, should be an apostrophe
    code = code.gsub("\u0092".encode('utf-8'), "'")
    # Same operation with the problematic character itself
    code = code.gsub("", "'")
    # Doomed characters break Hugo compilation
    DOOMED_CHARACTERS.each do |character|
      code = code.remove(character.encode('utf-8'))
    end
    code
  end
end
