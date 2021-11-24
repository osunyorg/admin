class Curator
  attr_reader :website, :user, :url, :post

  def initialize(website, user, url)
    @website = website
    @user = user
    @url = url
    create_post!
    attach_image! unless page.image.blank?
  end

  def valid?
    @post.valid?
  end

  protected

  def create_post!
    text = Wordpress.clean_html("#{page.text}<br><a href=\"#{@url}\" target=\"_blank\">Source</a>")
    @post = website.posts.create(
      university: website.university,
      title: page.title,
      text: text,
      slug: page.title.parameterize,
      author: @user.author,
      published_at: Time.now
    )
  end

  def attach_image!
    @post.featured_image.attach(
      io: URI.open(page.image),
      filename: File.basename(page.image).split('?').first
    )
  rescue
    puts "Attach image failed"
  end

  def page
    @page ||= Curation::Page.new(@url)
  end
end
