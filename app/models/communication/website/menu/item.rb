# == Schema Information
#
# Table name: communication_website_menu_items
#
#  id            :uuid             not null, primary key
#  about_type    :string           indexed => [about_id]
#  kind          :integer          default("blank")
#  position      :integer
#  title         :string
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed => [about_type]
#  menu_id       :uuid             not null, indexed
#  parent_id     :uuid             indexed
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
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
#  fk_rails_419ae3ca67  (menu_id => communication_website_menus.id)
#  fk_rails_7747922950  (university_id => universities.id)
#  fk_rails_d5e6210547  (parent_id => communication_website_menu_items.id)
#  fk_rails_fa4f4585e4  (website_id => communication_websites.id)
#
class Communication::Website::Menu::Item < ApplicationRecord
  include WithTree
  include WithPosition
  include WithTargets

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
    # Les méthodes target_for_ sont définies dans le concern WithTarget
    method = "target_for_#{kind}"
    # Le true sert à examiner les méthodes protected
    target = respond_to?(method, true)  ? send(method)
                                        : about&.path
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
    kind_page? ||
    kind_program? ||
    kind_news_category? ||
    kind_news_article? ||
    kind_research_volume? ||
    kind_research_article?
  end

  def sync_menu
    menu.sync_with_git if menu
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  protected

  def last_ordered_element
    menu.items.where(parent_id: parent_id).ordered.last
  end
end
