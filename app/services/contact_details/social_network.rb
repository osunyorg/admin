class ContactDetails::SocialNetwork < ContactDetails::Base

  protected

  def url
    ''
  end

  def prepare_value
    @value = "#{url}#{handle}"
  end

  def prepare_label
    @label = handle
  end

  def handle
    @string
  end
end