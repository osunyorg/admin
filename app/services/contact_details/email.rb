class ContactDetails::Email < ContactDetails::Base

  protected

  def prepare_url
    @url = "mailto:#{@string}"
  end

end