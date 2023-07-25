module Communication::Website::WithSecurity
  extend ActiveSupport::Concern

  def external_domains
    list = external_domains_default
    list.concat external_domains_plausible
    list.concat external_domains_from_blocks_video
    list.concat external_domains_from_blocks_embed
    list.uniq.compact
  end

  protected

  def external_domains_default
    [
      'osuny-1b4da.kxcdn.com', # KeyCDN for assets resize
      '*.osuny.org', # Osuny for assets resize
      'osuny.s3.fr-par.scw.cloud' # Scaleway for direct assets
    ]
  end

  def external_domains_plausible
    list = []
    list << URI.parse(plausible_url).host if plausible_url.present?
    list
  end

  def external_domains_from_blocks_video
    list = []
    blocks.where(template_kind: :video).each do |block|
      video_url = block.template.url
      list << URI.parse(video_url).host if url.present?
    end
    list
  end

  def external_domains_from_blocks_embed
    list = []
    blocks.where(template_kind: :embed).each do |block|
      code = block.template.code
      # https://stackoverflow.com/questions/25095176/extracting-all-urls-from-a-page-using-ruby
      code.scan(/[[:lower:]]+:\/\/[^\s"]+/).each do |url|
        url = CGI.unescapeHTML(url)
        url =  ActionController::Base.helpers.strip_tags(url)
        url = URI::Parser.new.escape(url)
        host = URI.parse(url).host
        list << host
      end
    end
    list
  end
end