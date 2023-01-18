class ContactDetails::Twitter < ContactDetails::Base
  URL = 'https://twitter.com/'
  DOMAIN = 'twitter.com'

  protected

  def prepare_value
    super
    @value.remove! DOMAIN if @value.start_with? DOMAIN
    @value.remove! URL if @value.start_with? URL
    @value.delete_suffix! '/'
    @value.delete_prefix! '/'
    @value = "#{URL}#{@value}"
  end

  def prepare_label
    @label = @value.remove URL
  end
end