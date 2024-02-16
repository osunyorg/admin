class Static::Html < Static::Default

  def prepared
    unless @prepared
      @prepared = @text.to_s.strip.dup
      @prepared.gsub! "\r", ''
      @prepared.gsub! "\n", ''
      @prepared = clean_empty_paragraphs_at_beginning_and_end @prepared
      @prepared.gsub! "\n", ' '
      @prepared = @prepared.ortho(locale: locale)
      @prepared.gsub! "/rails/active_storage", "#{@university.url}/rails/active_storage"      
      @prepared = sanitize @prepared
    end
    @prepared
  end

  private

  # based on https://stackoverflow.com/questions/17479135/how-do-i-trim-the-head-and-tail-of-empty-tags-in-html
  def clean_empty_paragraphs_at_beginning_and_end(text)
    return text unless text.present?
    doc = Nokogiri::HTML(text)
    ps = doc.xpath '/html/body/p'
    
    first_text = -1
    last_text = 0
    
    ps.each_with_index do |p, i|
      unless p.at_xpath('child::text()').nil? || p.at_xpath('child::text()').text.strip.empty?  #then found some text
        first_text = i if first_text == -1
        last_text = i 
      end
    end
    
    new_text = ps.slice(first_text .. last_text)
    new_text.nil? ? '' : new_text.to_html
  end

end