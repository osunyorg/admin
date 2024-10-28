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
  include Initials
  include Orderable
  include Sanitizable
  include WithTree
  include WithUniversity

  attr_accessor :skip_publication_callback

  ICONS = {
    'blank' => Icon::COMMUNICATION_WEBSITE_MENU_BLANK,
    'category' => Icon::COMMUNICATION_WEBSITE_POST,
    'diploma' => Icon::EDUCATION_DIPLOMA,
    'location' => Icon::ADMINISTRATION_CAMPUS,
    'page' => Icon::COMMUNICATION_WEBSITE_PAGE,
    'paper' => Icon::RESEARCH_LABORATORY,
    'post' => Icon::COMMUNICATION_WEBSITE_POST,
    'program' => Icon::EDUCATION_PROGRAM,
    'url' => Icon::COMMUNICATION_WEBSITE_MENU_URL,
    'volume' => Icon::RESEARCH_LABORATORY
  }.freeze

  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :menu, class_name: 'Communication::Website::Menu'
  belongs_to :parent, class_name: 'Communication::Website::Menu::Item', optional: true
  belongs_to :about, polymorphic: true, optional: true
  has_many   :children,
             class_name: 'Communication::Website::Menu::Item',
             foreign_key: :parent_id,
             dependent: :destroy

  enum :kind, {
    blank: 0,
    url: 10,
    page: 20,
    program: 31,
    diploma: 33,
    category: 41,
    post: 42,
    volume: 61,
    paper: 63,
    location: 70
  }, prefix: :kind

  validates :title, presence: true
  validates :about, presence: true, if: :has_about?

  after_commit :sync_menu

  delegate :language, to: :menu

  def self.icon_for(kind)
    ICONS[kind] if ICONS.has_key? kind
  end

  def self.collection_for(kind, website)
    case kind
    when 'page'
      website.pages.root
    when 'diploma'
      website.education_diplomas
    when 'program'
      website.education_programs.root
    when 'category'
      website.post_categories.root
    when 'post'
      website.posts
    when 'volume'
      website.research_volumes
    when 'paper'
      website.research_papers
    when 'location'
      website.administration_locations
    end
  end

  def to_s
    "#{title}"
  end

  def static_target
    test_kind_method = "menu_item_kind_#{kind}?"
    return nil if website.respond_to?(test_kind_method) && !website.public_send(test_kind_method)

    case kind
    when "blank"
      ''
    when "url"
      url
    else
      about_l10n = about.localization_for(language)
      if about_l10n.present?
        about_l10n_permalink = about_l10n.new_permalink_in_website(website)
        about_l10n_permalink.computed_path
      else
        nil
      end
    end
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
    kind_category? ||
    kind_diploma? ||
    kind_location? ||
    kind_page? ||
    kind_paper? ||
    kind_post? ||
    kind_program? ||
    kind_volume?
  end

  def sync_menu
    menu.sync_with_git if menu && !menu.destroyed?
  end

  def siblings
    self.class
        .unscoped
        .where(parent: parent, university: university, website: website)
        .where.not(id: id)
  end

  protected

  def last_ordered_element
    menu.items.where(parent_id: parent_id).ordered.last
  end
end
