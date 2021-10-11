class LocaleService

  ## Get best locale for a user
  def self.locale(user, accept_language_header)
    user&.language.nil? ? self.preferred_language(accept_language_header) : user.language.iso_code.to_sym
  end

  def self.preferred_language(brand_languages, accept_language_header)
    # browser_language > french
    browser_languages = accept_language_header&.scan(/\*|([a-z]{1,8}(?:-[A-Z0-9]{1,8})*)/i)&.flatten&.compact&.reject { |v| v == "q" }

    browser_languages&.each do |code|
      symbol = self.get_symbol(code)
      return symbol unless symbol.nil?
    end

    I18n.default_locale
  end

  def self.get_symbol(code)
    if Language.where(iso_code: code).any?
      symbol = code.to_sym
    elsif code.include?('-')
      # safari returns only "fr-fr", so if we only have "fr" active it fallbacks to english
      root_code = code.split('-').first
      symbol = root_code.to_sym if Language.where(iso_code: root_code).any?
    end
    symbol
  end
end
