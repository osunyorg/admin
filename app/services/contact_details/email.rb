class ContactDetails::Email < ContactDetails::Base
  PREFIX = "mailto:"

  protected

  def prepare_value
    @value = "#{PREFIX}#{@string}"
  end

end