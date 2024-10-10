class ContactDetails::Instagram < ContactDetails::SocialNetwork

  protected

  def url
    'https://instagram.com/'
  end

  def handle
    @handle ||=  @string.remove('https://')
                        .remove('http://')
                        .remove('www.')
                        .remove('instagram.com')
                        .remove('@')
                        .remove('/')
  end
end