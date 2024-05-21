class LanguageTool
  attr_reader :text, :language

  ENDPOINT = 'https://api.languagetoolplus.com'.freeze

  def self.check(text, language)
    new(text, language).check
  end

  def initialize(text, language)
    @text = text
    @language = language
  end

  def check
    connection.post('/v2/check', {
      text: text,
      language: language
    }).body
  end

  protected

  def connection
    @connection ||= Faraday.new(
      url: ENDPOINT,
      params: {
        username: ENV['LANGUAGE_TOOL_USERNAME'],
        apiKey: ENV['LANGUAGE_TOOL_API_KEY']
      }
    )
  end
end