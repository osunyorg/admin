class ContactDetails::Phone < ContactDetails::Base
  PREFIX = "tel:"

  protected

  def prepare_value
    super
    @value.remove! ' '
    @value.remove! '.'
    @value = "#{PREFIX}#{@value}"
  end

  def prepare_label
    @label = @value.remove PREFIX
  end
end