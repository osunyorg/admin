class ContactDetails::Facebook < ContactDetails::SocialNetwork

  protected

  def url
    'https://www.facebook.com/'
  end

  def handle
    @handle ||=  @string.remove('https://')
                        .remove('http://')
                        .remove('www.')
                        .remove('facebook.com')
                        .remove('@')
                        .remove('/')
  end
end