class ContactDetails::Twitter < ContactDetails::Base
  URL = 'https://twitter.com'
  DOMAIN = 'twitter.com'

  
  protected
  
  # arnaudlevy
  # twitter.com/arnaudlevy
  # https://twitter.com/arnaudlevy
  # TODO vrais tests
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