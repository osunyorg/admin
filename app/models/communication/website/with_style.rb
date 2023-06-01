module Communication::Website::WithStyle
  extend ActiveSupport::Concern

  def preview_style
    load_style if style_outdated?
    style
  end

  protected

  def load_style
    @style = ''
    load_style_from_website_url if url.present?
    load_style_from_example
    make_assets_relative!
    self.update_columns style: @style,
                        style_updated_at: Date.today
  end

  def load_style_from_website_url
    load_style_from url
    load_style_from "#{url}/fr" if @style.blank?
    load_style_from "#{url}/en" if @style.blank?
  end

  def load_style_from_example
    load_style_from "https://example.osuny.org" if @style.blank?
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

  # /assets/fonts/Aestetico-Light/font.woff2
  # referring to 
  # https://www.osuny.org/assets/fonts/Aestetico-Light/font.woff2
  # becomes 
  # assets/fonts/Aestetico-Light/font.woff2
  # referring to 
  # httsp://demo.osuny.org/admin/communication/websites/6d8fb0bb-0445-46f0-8954-0e25143e7a58/assets/fonts/Aestetico-Light/font.woff2
  # which is managed by the assets route, to avoid CORS issues
  def make_assets_relative!
    @style.gsub! "url(/assets", "url(assets"
    @style.gsub! "url(../", "url(assets/"
  end

  def style_outdated?
    style_updated_at.nil? || style_updated_at < Date.yesterday
    true
  end

end