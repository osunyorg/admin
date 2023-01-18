class ContactDetails::Website < ContactDetails::Base
  PROTOCOL = 'https://'

  protected

  def prepare_url
    @url = @string
    @url = "#{PROTOCOL}#{@url}" unless @url.start_with? PROTOCOL
  end

  def prepare_label
    @label = @url.remove PROTOCOL
  end
end