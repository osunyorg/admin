class ContactDetails::Country < ContactDetails::Base

  protected

  def prepare_label
    super
    # TODO country name
  end

end