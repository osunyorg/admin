class ContactDetails::Twitter < ContactDetails::SocialNetwork

  protected

  def url
    'https://x.com/'
  end

  def handle
    @handle ||=  @string.remove('https://')
                        .remove('http://')
                        .remove('www.')
                        .remove('x.com')
                        .remove('twitter.com')
                        .remove('@')
                        .remove('/')
  end
end