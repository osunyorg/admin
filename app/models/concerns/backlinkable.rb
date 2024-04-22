module Backlinkable
  extend ActiveSupport::Concern

  def backlinks_pages(website)
    backlinks(
      "Communication::Website::Page",
      website
    )
    .reject { |page| page.is_special_page? }
  end

  def backlinks_posts(website)
    backlinks(
      "Communication::Website::Post",
      website
    )
  end

  def backlinks_agenda_events(website)
    backlinks(
      "Communication::Website::Agenda::Event",
      website
    )
  end

  protected

  def backlinks(kind, website)
    backlinks_object_ids = published_backlinks_blocks(website).map { |block|
      block.about_id if backlink_in_block?(block, kind, website)
    }.compact
    kind.safe_constantize.published.where(communication_website_id: website.id, id: backlinks_object_ids)
  end

  def backlink_in_block?(block, kind, website)
    block.about_type == kind && # Correct kind
    block.about_id.in?(published_backlinks_object_ids(website, kind)) && # About published
    self.id.in?(block.template.children_ids) # Mentioning self
  end

  def published_backlinks_object_ids(website, kind)
    @published_backlinks_object_ids ||= {}
    @published_backlinks_object_ids[website.id] ||= kind.safe_constantize.published.where(communication_website_id: website.id).pluck(:id)
  end

  def published_backlinks_blocks(website)
    @published_backlinks_blocks ||= {}
    @published_backlinks_blocks[website.id] ||= backlinks_blocks(website).published
  end

  def backlinks_blocks(website)
    raise NotImplementedError
  end
end