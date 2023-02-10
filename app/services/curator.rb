class Curator
  attr_reader :website, :user, :language, :url, :post

  def initialize(website, user, language, url)
    @website = website
    @user = user
    @language = language
    @url = url
    create_post!
    attach_image! unless page.image.blank?
  rescue
  end

  def valid?
    @post.valid?
  end

  protected

  def create_post!
    @post = website.posts.create(
      university: website.university,
      title: page.title,
      slug: page.title.parameterize,
      author: @user.person,
      published_at: Time.now,
      language_id: @language.id
    )
    @chapter = @post.blocks.create(
      university: website.university,
      template_kind: :chapter,
      published: true,
      position: 0
    )
    text = Wordpress.clean_html("#{page.text}<p><a href=\"#{@url}\" target=\"_blank\">Source</a></p>")
    data = @chapter.data.deep_dup
    data['text'] = text
    @chapter.data = data
    @chapter.save
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
