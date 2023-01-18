class ContactDetails::Country < ContactDetails::Base

  protected

  def prepare_label
    @label = ISO3166::Country[@string].common_name
  end

end