class DomCount

  LEVEL_1 = 300
  LEVEL_2 = 600
  LEVEL_3 = 900
  LEVEL_4 = 2000

  self.level_for_count(count)
    if count < LEVEL_1
      :one
    elsif count < LEVEL_2
      :two
    elsif count < LEVEL_3
      :three
    elsif count < LEVEL_4
      :four
    else
      :five
    end
  end

  def self.count_in_html(html)
    Nokogiri::HTML(html).css('*').count
  end

end