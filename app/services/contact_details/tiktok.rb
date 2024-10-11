class ContactDetails::Tiktok < ContactDetails::SocialNetwork

  protected

  def url
    'https://www.tiktok.com/@'
  end

  def handle
    @handle ||=  @string.remove('https://')
                        .remove('http://')
                        .remove('www.')
                        .remove('tiktok.com')
                        .remove('@')
                        .remove('/')
  end
end