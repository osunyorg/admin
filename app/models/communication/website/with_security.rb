module Communication::Website::WithSecurity
  extend ActiveSupport::Concern

  def external_domains
    list = external_domains_default
    list.concat external_domains_plausible
    list.concat external_domains_from_blocks_video
    list.concat external_domains_from_blocks_embed(blocks)
    list.concat external_domains_from_blocks_embed(blocks_from_education)
    list.concat external_domains_from_blocks_embed(blocks_from_research)
    list.concat external_domains_from_blocks_embed(blocks_from_university)
    list.uniq.compact
  end

  protected

  def external_domains_default
    [
      ENV['KEYCDN_HOST'],           # KeyCDN for assets resize
      '*.osuny.org',                # Osuny for assets resize
      'osuny.s3.fr-par.scw.cloud',  # Scaleway for direct assets
      'tile.openstreetmap.org'      # Open Street Map default tiles
    ].compact
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
      next unless video_url.present?
      list.concat Video::Provider.find(video_url).csp_domains
    end
    list
  end

  def external_domains_from_blocks_embed(blocks)
    list = []
    blocks.where(template_kind: :embed).published.each do |block|
      code = block.template.code
      # https://stackoverflow.com/questions/25095176/extracting-all-urls-from-a-page-using-ruby
      code.scan(/[[:lower:]]+:\/\/[^\s"]+/).each do |url|
        url = CGI.unescapeHTML(url)
        url = ActionController::Base.helpers.strip_tags(url)
        url = URI::Parser.new.escape(url)
        host = URI.parse(url).host
        list << host
      end
    end
    list
  end
end