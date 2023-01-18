class ContactDetails::Phone < ContactDetails::Base

  protected

  def prepare_url
    @url = @string.dup
    @url.remove! ' '
    @url.remove! '.'
  end

  def prepare_label
    @label = @string
  end
end