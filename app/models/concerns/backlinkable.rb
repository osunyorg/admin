module Backlinkable
  extend ActiveSupport::Concern

  BACKLINKS = [
    :pages,
    :posts,
    :events,
    :exhibitions,
    :projects
  ]

  def backlinks_for(website)
    base = {}
    BACKLINKS.each do |identifier|
      elements = elements_with_hugo(identifier, website)
      base[identifier] = elements if elements.any?
    end
    base
  end

  protected

  def elements_with_hugo(identifier, website)
    elements = []
    elements_for_backlink(identifier, website).each do |element|
      hugo = element.hugo(website)
      next if hugo.nil? || hugo.file.blank?
      elements << {
        element: element,
        hugo: hugo
      }
    end
    elements
  end

  def elements_for_backlink(identifier, website)
    method = "backlinks_#{identifier}"
    send(method, website)
  end

  # TODO: Optimize this method
  def backlinks_pages(website)
    special_page_ids = website.pages.where.not(type: nil).pluck(:id)
    backlinks(
      "Communication::Website::Page::Localization",
      website
    )
    .reject { |page_l10n| special_page_ids.include?(page_l10n.about_id) }
  end

  def backlinks_posts(website)
    backlinks(
      "Communication::Website::Post::Localization",
      website
    )
  end

  def backlinks_events(website)
    backlinks(
      "Communication::Website::Agenda::Event::Localization",
      website
    )
  end

  def backlinks_exhibitions(website)
    backlinks(
      "Communication::Website::Agenda::Exhibition::Localization",
      website
    )
  end

  def backlinks_projects(website)
    backlinks(
      "Communication::Website::Portfolio::Project::Localization",
      website
    )
  end

  def backlinks(kind, website)
    backlinks_object_ids = published_backlinks_blocks(website).map { |block|
      block.about_id if backlink_in_block?(block, kind, website)
    }.compact
    kind.safe_constantize.published.where(communication_website_id: website.id, id: backlinks_object_ids)
  end

  def backlink_in_block?(block, kind, website)
    block.about_type == kind && # Correct kind
    block.about_id.in?(published_backlinks_localization_ids(website, kind)) && # About published
    self.about_id.in?(block.template.children_ids) # Mentioning self
  end

  def published_backlinks_localization_ids(website, kind)
    # Looking for published localization IDs within the website, for current language
    # Memoize to avoid multiple queries for the same website and kind
    @published_backlinks_localization_ids ||= {}
    @published_backlinks_localization_ids[website.id] ||= {}
    @published_backlinks_localization_ids[website.id][kind] ||= kind.safe_constantize
                                                              .published
                                                              .where(communication_website_id: website.id, language_id: language_id)
                                                              .pluck(:id)
  end

  def published_backlinks_blocks(website)
    # Memoize to avoid multiple queries for the same website
    @published_backlinks_blocks ||= {}
    @published_backlinks_blocks[website.id] ||= backlinks_blocks(website).published
  end

  def backlinks_blocks(website)
    raise NoMethodError, "You must implement the `backlinks_blocks` method in #{self.class.name}"
  end
end
