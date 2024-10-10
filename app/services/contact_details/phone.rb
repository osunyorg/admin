class ContactDetails::Phone < ContactDetails::Base

  protected

  def prepare_value
    super
    @value.remove! ' '
    @value.remove! '.'
    @value = "tel:#{@value}"
  end

  def prepare_label
    super
    @label.gsub! '.', ' '
  end
end