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
  has_many :children,
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
    case self.kind
    when 'url'
      target = url
    when 'page'
      target = about.path if about&.published
    when 'news_article'
      target = about.path if about&.published_at
    when 'programs'
      target = "/#{website.programs_github_directory}" if website.programs.any?
    when 'program'
      target = "/#{website.programs_github_directory}#{about.path}" if website.about_school?
    when 'news'
      target = "/#{website.posts_github_directory}" if website.posts.published.any?
    when 'staff'
      target = "/#{website.staff_github_directory}" if website.people.any?
    when 'research_volumes'
      target = "/#{website.research_volumes_github_directory}" if website.research_volumes.published.any?
    when 'research_volume'
      target = "/#{website.research_volumes_github_directory}#{about.path}" if about&.published_at
    when 'research_articles'
      target = "/#{website.research_articles_github_directory}" if website.research_articles.published.any?
    when 'research_article'
      target = "/#{website.research_articles_github_directory}#{about.path}" if about&.published_at
    when 'blank'
      target = ''
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
