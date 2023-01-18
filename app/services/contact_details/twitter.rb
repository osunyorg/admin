class ContactDetails::Twitter < ContactDetails::Base
  URL = 'https://twitter.com/'
  DOMAIN = 'twitter.com'

  protected

  def prepare_url
    super
    @url.remove! DOMAIN if @url.start_with? DOMAIN
    @url.remove! URL if @url.start_with? URL
    @url.delete_suffix! '/'
    @url.delete_prefix! '/'
    @url = "#{URL}#{@url}"
  end

  def prepare_label
    @label = @url.remove URL
  end
end