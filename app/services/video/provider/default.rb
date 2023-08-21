class Video::Provider::Default
  DOMAINS = []

  attr_reader :video_url

  include ActionView::Helpers::TagHelper

  def initialize(video_url)
    @video_url = video_url
  end

  def platform
    self.class.name.demodulize.downcase.to_sym
  end

  def iframe_url
    video_url
  end

  def iframe_host
    URI.parse(iframe_url).host
  end

  def iframe_tag(**iframe_options)
    content_tag(:iframe, nil, default_iframe_options.merge(iframe_options))
  end

  def correct?
    url_in_domains?
  end

  def default_iframe_options
    {
      class: (platform == :default ? nil : platform),
      loading: 'lazy',
      src: iframe_url
    }
  end

  protected

  def url_in_domains?
    self.class::DOMAINS.any? do |domain|
      video_url.include?(domain)
    end
  end
end
