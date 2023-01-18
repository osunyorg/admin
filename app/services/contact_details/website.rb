class ContactDetails::Website < ContactDetails::Base
  PROTOCOL = 'https://'

  protected

  def prepare_value
    super
    @value = "#{PROTOCOL}#{@value}" unless @value.start_with? PROTOCOL
  end

  def prepare_label
    @label = @value.remove PROTOCOL
  end
end