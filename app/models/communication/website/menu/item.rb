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
  KINDS_FOR_SCHOOL = ['programs', 'program', 'administrators', 'teachers']
  KINDS_FOR_JOURNAL = ['researchers', 'research_volumes', 'research_volume', 'research_articles', 'research_article']

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

  def self.kinds_for_website(website)
    whitelisted_kinds = self.kinds.dup

    KINDS_FOR_SCHOOL.each { |school_kind|
      whitelisted_kinds.delete(school_kind)
    } unless website.about_school?
    KINDS_FOR_JOURNAL.each { |journal_kind|
      whitelisted_kinds.delete(journal_kind)
    } unless website.about_journal?

    whitelisted_kinds
  end

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
    when 'programs'
      target = "/#{website.static_pathname_programs}" if website.programs.any?
    when 'program'
      target = "/#{website.static_pathname_programs}#{about.path}" if website.about_school?
    when 'news'
      target = "/#{website.static_pathname_posts}" if website.posts.published.any?
    when 'news_article'
      target = "/#{website.static_pathname_posts}#{about.path}" if about&.published_at
    when 'staff'
      target = "/#{website.static_pathname_staff}" if website.people.any?
    when 'administrators'
      target = "/#{website.static_pathname_administrators}" if website.university_people_through_administrators.any?
    when 'authors'
      target = "/#{website.static_pathname_authors}" if website.authors.compact.any?
    when 'researchers'
      target = "/#{website.static_pathname_researchers}" if website.research_articles.collect(&:researchers).flatten.any?
    when 'teachers'
      target = "/#{website.static_pathname_teachers}" if website.programs.collect(&:university_people_through_teachers).flatten.any?
    when 'research_volumes'
      target = "/#{website.static_pathname_research_volumes}" if website.research_volumes.published.any?
    when 'research_volume'
      target = "/#{website.static_pathname_research_volumes}#{about.path}" if about&.published_at
    when 'research_articles'
      target = "/#{website.static_pathname_research_articles}" if website.research_articles.published.any?
    when 'research_article'
      target = "/#{website.static_pathname_research_articles}#{about.path}" if about&.published_at
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
