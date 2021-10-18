class Wordpress
  attr_reader :domain

  def self.clean(html)
    fragment = Sanitize.fragment(html, Sanitize::Config::RELAXED)
    fragment = Nokogiri::HTML5.fragment(fragment)
    if fragment.css('h1').any?
      # h1 => h2 ; h2 => h3 ; ...
      (1..5).to_a.reverse.each do |i|
        fragment.css("h#{i}").each { |element| element.name = "h#{i+1}" }
      end
    end
    fragment.to_html(preserve_newline: true)
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
