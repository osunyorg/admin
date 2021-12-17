class Wordpress
  attr_reader :url


  def self.clean_string(string)
    string = string.gsub('&nbsp;', ' ')
    string = string.gsub('&amp;', '&')
    string = ActionView::Base.full_sanitizer.sanitize string
    string = remove_control_chars string
    string
  end

  def self.clean_html(html)
    # Relaxed config : https://github.com/rgrove/sanitize/blob/main/lib/sanitize/config/relaxed.rb
    # iframe attributes from MDN : https://developer.mozilla.org/fr/docs/Web/HTML/Element/iframe
    fragment = Sanitize.fragment(html, Sanitize::Config.merge(Sanitize::Config::RELAXED,
      attributes: Sanitize::Config::RELAXED[:attributes].merge({
        all: Sanitize::Config::RELAXED[:attributes][:all].dup - ['class', 'style'],
        'a' => Sanitize::Config::RELAXED[:attributes]['a'].dup.delete('rel'),
        'iframe' => [
          'allow', 'allowfullscreen', 'allowpaymentrequest', 'csp', 'height', 'loading',
          'name', 'referrerpolicy', 'sandbox', 'src', 'srcdoc', 'width', 'align',
          'frameborder', 'longdesc', 'marginheight', 'marginwidth', 'scrolling'
        ]
      }),
      elements: Set.new(Sanitize::Config::RELAXED[:elements]) - ['div', 'style'] + ['iframe'],
      remove_contents: ['math', 'noembed', 'noframes', 'noscript', 'plaintext', 'script', 'style', 'svg', 'xmp'],
      whitespace_elements: {
        'div' => { :before => "", :after => "" }
      }
    ))
    fragment = Nokogiri::HTML5.fragment(fragment)
    if fragment.css('h1').any?
      # h1 => h2 ; h2 => h3 ; ...
      (1..5).to_a.reverse.each do |i|
        fragment.css("h#{i}").each { |element| element.name = "h#{i+1}" }
      end
    end
    html = fragment.to_html(preserve_newline: true)
    html = remove_control_chars html
    html
  end

  def self.remove_control_chars(string)
    # Control chars & LSEP are invisible or hard to detect
    string = string.delete(" ", "&#8232;", "&#x2028;", "")
    string = string.gsub /\u2028/, ''
    string
  end

  def initialize(url)
    @url = url
  end

  def authors
    load "#{url}/wp-json/wp/v2/users"
  end

  def categories
    load "#{url}/wp-json/wp/v2/categories"
  end

  def posts
    load "#{url}/wp-json/wp/v2/posts"
  end

  def pages
    load "#{url}/wp-json/wp/v2/pages"
  end

  def media
    load "#{url}/wp-json/wp/v2/media"
  end

  protected

  def load(url)
    page = 1
    posts = []
    loop do
      batch = load_paged url, page
      break if batch.is_a?(Hash) || batch.empty?
      posts += batch
      page += 1
    end
    posts
  end

  def load_paged(url, page)
    puts "Load #{url } on page #{page}"
    load_url "#{url}?page=#{page}&per_page=100"
  end

  def load_url(url)
    download_service = DownloadService.download(url)
    JSON.parse(download_service.response.body)
  end
end
