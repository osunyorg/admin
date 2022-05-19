class SummernoteCleaner
  def self.clean(text)
    clean_text = text
    unless text.start_with? '<p>'
      chunks = clean_text.split '<p>'
      chunks[0] = "<p>#{chunks[0]}</p>"
      clean_text = chunks.join '<p>'
    end
    clean_text
  end
end
