class ContactDetails::Email < ContactDetails::Base
  PREFIX = "mailto:"

  protected

  def prepare_url
    @url = "#{PREFIX}#{@string}"
  end

end