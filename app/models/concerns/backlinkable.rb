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
      block.about if backlink_in_block?(block, kind)
    }.compact
  end

  def backlink_in_block?(block, kind)
    block.about.is_a?(kind) && # Correct kind
    self.in?(block.template.children) && # Mentioning self
    block.about.published? # About published
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