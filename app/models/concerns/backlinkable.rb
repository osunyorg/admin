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
    backlinks_blocks(website).published.map { |block|
      # Correct kind
      next unless block.about.is_a?(kind)
      # Mentioning self
      next unless self.in?(block.template.children)
      # About published
      next unless block.about.published?
      block.about
    }.compact
  end

  def backlinks_blocks(website)
    case self.class.to_s
    when 'University::Organization'
      website.blocks.organizations
    when 'University::Person'
      website.blocks.persons
    else
      raise "#{self.class} should map to the correct kind of blocks"
    end
  end
end