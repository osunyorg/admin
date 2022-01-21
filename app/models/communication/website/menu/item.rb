# == Schema Information
#
# Table name: communication_website_menu_items
#
#  id            :uuid             not null, primary key
#  about_type    :string
#  kind          :integer          default("blank")
#  position      :integer
#  title         :string
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid
#  menu_id       :uuid             not null
#  parent_id     :uuid
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_menu_items_on_about          (about_type,about_id)
#  index_communication_website_menu_items_on_menu_id        (menu_id)
#  index_communication_website_menu_items_on_parent_id      (parent_id)
#  index_communication_website_menu_items_on_university_id  (university_id)
#  index_communication_website_menu_items_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (menu_id => communication_website_menus.id)
#  fk_rails_...  (parent_id => communication_website_menu_items.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_websites.id)
#
class Communication::Website::Menu::Item < ApplicationRecord
  include WithTree
  include WithPosition

  attr_accessor :skip_publication_callback

  belongs_to :university
  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :menu, class_name: 'Communication::Website::Menu'
  belongs_to :parent, class_name: 'Communication::Website::Menu::Item', optional: true
  belongs_to :about, polymorphic: true, optional: true
  has_many   :children,
             class_name: 'Communication::Website::Menu::Item',
             foreign_key: :parent_id,
             dependent: :destroy

  enum kind: {
    blank: 0,
    url: 10,
    page: 20,
    programs: 30,
    program: 31,
    news: 40,
    news_category: 41,
    news_article: 42,
    staff: 50,
    administrators: 51,
    authors: 52,
    researchers: 53,
    teachers: 54,
    research_volumes: 60,
    research_volume: 61,
    research_articles: 62,
    research_article: 63
  }, _prefix: :kind

  validates :title, presence: true
  validates :about, presence: true, if: :has_about?

  after_commit :sync_menu

  def to_s
    "#{title}"
  end

  def static_target
    target = nil
    active = website.send "menu_item_kind_#{kind}?"
    return nil unless active
    published = about&.published && about&.published_at
    case self.kind
    when 'blank'
      target = ''
    when 'url'
      target = url
    when 'page'
      target = about.path if about&.published
    when 'programs'
      target = "/#{website.static_pathname_programs}"
    when 'program'
      target = "/#{website.static_pathname_programs}#{about.path}"
    when 'news'
      target = "/#{website.static_pathname_posts}"
    when 'news_article'
      target = "/#{website.static_pathname_posts}#{about.path}" if published
    when 'staff'
      target = "/#{website.static_pathname_staff}"
    when 'administrators'
      target = "/#{website.static_pathname_administrators}"
    when 'authors'
      target = "/#{website.static_pathname_authors}"
    when 'researchers'
      target = "/#{website.static_pathname_researchers}"
    when 'teachers'
      target = "/#{website.static_pathname_teachers}"
    when 'research_volumes'
      target = "/#{website.static_pathname_research_volumes}"
    when 'research_volume'
      target = "/#{website.static_pathname_research_volumes}#{about.path}" if published
    when 'research_articles'
      target = "/#{website.static_pathname_research_articles}"
    when 'research_article'
      target = "/#{website.static_pathname_research_articles}#{about.path}" if published
    else
      target = about&.path
    end
    return nil if target.nil?
    target.end_with?('/') ? target
                          : "#{target}/"
  end

  def list_of_other_items
    items = []
    menu.items.where.not(id: id).root.ordered.each do |item|
      items.concat(item.self_and_children(0))
    end
    items.reject! { |p| p[:id] == id }
    items
  end

  def to_static_hash
    return nil if static_target.nil?
    {
      'title' => title,
      'target' => static_target,
      'kind' => kind,
      'children' => children.ordered.map(&:to_static_hash).compact
    }
  end

  def has_about?
    kind_page? || kind_program? ||
    kind_news_category? || kind_news_article? ||
    kind_research_volume? || kind_research_article?
  end

  def sync_menu
    menu.sync_with_git
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  protected

  def last_ordered_element
    menu.items.where(parent_id: parent_id).ordered.last
  end
end
