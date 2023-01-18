class ContactDetails::Twitter < ContactDetails::Base
  URL = 'https://twitter.com'
  DOMAIN = 'twitter.com'
  
  protected

  def prepare_url
    @url = @string
    @url.remove! DOMAIN if @url.start_with? DOMAIN
    @url.remove! URL if @url.start_with? URL
    @url.delete_suffix! '/'
    @url.delete_prefix! '/'
    @url = "#{URL}/#{@string}"
  end
  
  def prepare_label
    super
    @label.remove! URL
  end
end