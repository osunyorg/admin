class ContactDetails::Phone < ContactDetails::Base
  PREFIX = "tel:"

  protected

  def prepare_url
    super
    @url.remove! ' '
    @url.remove! '.'
    @url = "#{PREFIX}#{@url}"
  end

  def prepare_label
    @label = @url.remove PREFIX
  end
end