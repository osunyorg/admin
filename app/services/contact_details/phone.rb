class ContactDetails::Phone < ContactDetails::Base

  protected

  def prepare_value
    super
    [' ', '.', '-'].each do |string|
      @value.remove! string
    end
    @value = "tel:#{@value}"
  end

  def prepare_label
    super
    ['.', '-'].each do |string|
      @label.gsub! string, ' '
    end
  end
end