module Backlinkable
  extend ActiveSupport::Concern

  def backlinks_pages(website)
    backlinks(
      Communication::Website::Page,
      website
    )
    .reject { |page| page.is_special_page? }
  end

  def backlinks_posts(website)
    backlinks(
      Communication::Website::Post,
      website
    )
  end

  def backlinks_agenda_events(website)
    backlinks(
      Communication::Website::Agenda::Event,
      website
    )
  end

  protected

  def backlinks(kind, website)
    connections
      .where(
        direct_source_type: kind.to_s,
        website_id: website.id
      )
      .collect(&:direct_source)
      .compact
      .select { |source| source.published? }
      .select { |source| source.language == language }
  end
end