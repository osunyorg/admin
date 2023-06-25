class ContactDetails::Website < ContactDetails::Base
  PROTOCOL = 'https://'

  protected

  def prepare_value
    super
    if @value.start_with?('http://')
      # Do nothing, this is oldie
    elsif !@value.start_with?(PROTOCOL)
      # www.test.com -> https://www.test.com
      @value = "#{PROTOCOL}#{@value}"
    end
  end

  def prepare_label
    @label = @value.remove PROTOCOL
    # Remove whatever//
    @label = @label.split('//').last
  end
end