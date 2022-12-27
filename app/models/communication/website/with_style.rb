module Communication::Website::WithStyle
  extend ActiveSupport::Concern

  def preview_style
    load_style if style_outdated? 
    style
  end

  protected

  def load_style
    @style = ''
    load_style_from url 
    load_style_from "#{url}/fr" if @style.blank?
    load_style_from "#{url}/en" if @style.blank?
    load_style_from "https://example.osuny.org" if @style.blank?
    substitute_fonts_urls_in_style!
    self.update_columns style: @style, 
                        style_updated_at: Date.today
  end

  def load_style_from(url)
    data = URI.open url
    html = Nokogiri::HTML data
    css_files = html.xpath '//link[@rel="stylesheet"]/@href'
    css_files.each do |css_url|
      add_css_url_to_style css_url.to_s
    end
  rescue
  end

  def add_css_url_to_style(css_url)
    @style << URI.open(css_url).read
  end

  def substitute_fonts_urls_in_style!
    @style.gsub! "src:url(../", "src:url(#{url}/assets/"
    @style.gsub ",url(../", ",url(#{url}/assets/"
  end

  def style_outdated?
    style_updated_at.nil? || style_updated_at < Date.yesterday 
  end
    
end