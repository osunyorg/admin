
class Osuny::LanguageTool
  attr_reader :text, :language

  def initialize(text, language)
    @text = text
    @language = language
  end

  def html_with_suggestions
    replace_matches
  rescue
    @text
  end

  protected

  def api_response
    @api_response ||= api.check text: text, language: language
  end

  def api
    @api ||= LanguageTool::API.new(
      base_uri: 'https://api.languagetoolplus.com/v2',
      common_query_params: {
        username: ENV['LANGUAGE_TOOL_USERNAME'],
        api_key: ENV['LANGUAGE_TOOL_API_KEY']
      }
    )
  end

  def matches
    @matches ||= api_response.matches
  end

  def replace_matches
    text_replaced = text
    matches.reverse.each do |match|
      offset = match.offset
      length = match.length
      text_before_replacement = text_replaced[offset, length]
      replacement = prepare_match(text_before_replacement, match)
      text_replaced.slice! offset, length
      text_replaced.insert offset, replacement
    end
    text_replaced
  end

  def prepare_match(text_before_replacement, match)
    category = match.rule.category.id
    puts category
    message = match.message
    replacements = match.replacements
    # Les classes seront supprimées à la sauvegarde
    html = "<span class=\"languagetool languagetool__#{category}\">"
    html += text_before_replacement
    # La balise custom languagetoolsuggestion sera supprimée à la sauvegarde
    html += '<languagetoolsuggestion class="languagetool__suggestion">'
    html += "<span class=\"languagetool__suggestion__message\">#{message}</span>"
    html += "<span class=\"languagetool__suggestion__replacements\">"
    replacements.each do |replacement|
      html += "<span class=\"languagetool__suggestion__replacement\">#{replacement}</span>"
    end
    html += "</span>"
    # html += match.to_s
    html += "</languagetoolsuggestion>"
    html += "</span>"
    html
  end
end