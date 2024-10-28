class ContactDetails::Github < ContactDetails::SocialNetwork

  protected

  def url
    'https://github.com/'
  end

  def handle
    @handle ||=  @string.remove('https://')
                        .remove('http://')
                        .remove('www.')
                        .remove('github.com')
                        .remove('@')
                        .delete_prefix('/')
  end
end