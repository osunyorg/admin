# encoding: utf-8
String.class_eval do

  # Time in seconds
  # 
  def reading_time
    # https://www.sciencedirect.com/science/article/abs/pii/S0749596X19300786
    words_per_minute = 238
    (60.0 * words / words_per_minute).round
  end

  def words
    self.scan(/(\w|-)+/).size
  end
end