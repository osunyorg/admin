class Communication::Website::IndexPage::CommunicationPosts < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::CommunicationPosts'
  end

  def git_path(website)
    'content/posts/_index.html'
  end

  def url
    "/#{website.index_for(:communication_posts).path}/"
  end

end
