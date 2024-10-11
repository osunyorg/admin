class ContactDetails::Vimeo < ContactDetails::SocialNetwork

  protected

  def url
    'https://vimeo.com/'
  end

  def handle
    @handle ||=  @string.remove('https://')
                        .remove('http://')
                        .remove('www.')
                        .remove('vimeo.com')
                        .remove('@')
                        .remove('/')
  end
end