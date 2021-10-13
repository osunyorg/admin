class Wordpress
  attr_reader :domain

  # Test in console with:
  # reload! && Communication::Website::Imported::Post.first.save && Communication::Website::Imported::Post.first.post.text
  # R&D:
  # https://github.com/rails/rails-html-sanitizer
  # https://github.com/gjtorikian/html-pipeline
  # https://github.com/rgrove/sanitize
  def self.clean(html)
    Sanitize.fragment html, Sanitize::Config::RELAXED
    # html
  end

  def initialize(domain)
    @domain = domain
  end

  def posts
    load "#{domain}/wp-json/wp/v2/posts"
  end

  def pages
    load "#{domain}/wp-json/wp/v2/pages"
  end

  protected

  def load(url)
    page = 1
    posts = []
    loop do
      batch = load_paged url, page
      puts "Load page #{page}"
      break if batch.is_a?(Hash) || batch.empty?
      posts += batch
      page += 1
    end
    posts
  end

  def load_paged(url, page)
    load_url "#{url}?page=#{page}&per_page=100"
  end

  def load_url(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # IUT Bordeaux Montaigne pb with certificate
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    JSON.parse(response.body)
  end
end
