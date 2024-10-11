class ContactDetails::Youtube < ContactDetails::SocialNetwork

  protected

  def url
    'https://www.youtube.com/@'
  end

  def handle
    @handle ||=  @string.remove('https://')
                        .remove('http://')
                        .remove('www.')
                        .remove('youtube.com')
                        .remove('youtu.be')
                        .remove('@')
                        .remove('/')
  end
end