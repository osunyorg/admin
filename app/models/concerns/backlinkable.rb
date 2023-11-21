module Backlinkable
  extend ActiveSupport::Concern

  def backlinks_pages(website)
    backlinks(
      Communication::Website::Page,
      website
    )
    .collect(&:direct_source)
    .compact
    .reject { |page| page.is_special_page? }
    .reject { |page| !page.published? }
  end

  def backlinks_posts(website)
    backlinks(
      Communication::Website::Post,
      website
    )
    .collect(&:direct_source)
    .compact
    .reject { |page| !page.published? }
  end

  def backlinks_agenda_events(website)
    backlinks(
      Communication::Website::Agenda::Event,
      website
    )
    .collect(&:direct_source)
    .compact
    .reject { |event| !event.published? }
  end

  protected

  def backlinks(kind, website)
    connections.where(
      direct_source_type: kind.to_s,
      website_id: website.id
    )
  end
end