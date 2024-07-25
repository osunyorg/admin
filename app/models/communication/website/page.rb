# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  breadcrumb_title         :string
#  featured_image_alt       :string
#  featured_image_credit    :text
#  full_width               :boolean          default(FALSE)
#  header_cta               :boolean          default(FALSE)
#  header_cta_label         :string
#  header_cta_url           :string
#  header_text              :text
#  kind                     :integer
#  meta_description         :text
#  migration_identifier     :string
#  position                 :integer          default(0), not null
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :string           indexed
#  summary                  :text
#  text                     :text
#  title                    :string
#  type                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  original_id              :uuid             indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_pages_on_communication_website_id  (communication_website_id)
#  index_communication_website_pages_on_language_id               (language_id)
#  index_communication_website_pages_on_original_id               (original_id)
#  index_communication_website_pages_on_parent_id                 (parent_id)
#  index_communication_website_pages_on_slug                      (slug)
#  index_communication_website_pages_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1a42003f06  (parent_id => communication_website_pages.id)
#  fk_rails_280107c62b  (communication_website_id => communication_websites.id)
#  fk_rails_304f57360f  (original_id => communication_website_pages.id)
#  fk_rails_d208d15a73  (university_id => universities.id)
#

class Communication::Website::Page < ApplicationRecord
  # FIXME: Remove legacy column from db
  # kind was replaced by type in January 2023
  self.ignored_columns = %w(path kind)

  include AsDirectObject
  include Contentful # TODO L10N : To remove
  include Sanitizable
  include Shareable # TODO L10N : To remove
  include Localizable
  # include WithAutomaticMenus # TODO L10N : To restore
  include WithBlobs # TODO L10N : To remove
  include WithDuplication # TODO L10N : To adjust
  include WithFeaturedImage # TODO L10N : To remove
  include WithMenuItemTarget
  # TODO L10N : To adjust (WithType)
  include WithType # WithType can set default publication status, so must be included before WithPublication
  include WithPosition # Scope :ordered must override WithPublication
  include WithTree
  include WithUniversity

  has_summernote :text # TODO: Remove text attribute

  # TODO L10N : remove after migrations
  has_many  :permalinks,
            class_name: "Communication::Website::Permalink",
            as: :about,
            dependent: :destroy

  belongs_to :parent,
             class_name: 'Communication::Website::Page',
             optional: true
  has_many   :children,
             class_name: 'Communication::Website::Page',
             foreign_key: :parent_id,
             dependent: :destroy

  after_save :touch_elements_if_special_page_in_hierarchy

  scope :latest, -> { published.order(updated_at: :desc).limit(5) }

  # TODO L10N : to adjust
  scope :ordered_by_title, -> { order(:title) }

  # TODO L10N : to adjust
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_website_pages.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_pages.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_pages.title) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  # TODO L10N : to adjust
  scope :for_published, -> (published) { where(published: published == 'true') }
  # TODO L10N : to adjust
  scope :for_full_width, -> (full_width) { where(full_width: full_width == 'true') }

  def dependencies
    [localizations]
  end

  def references
    [parent] +
    siblings +
    website.menus +
    abouts_with_page_block
  end

  def best_breadcrumb_title_in(language)
    best_localization_for(language).best_breadcrumb_title
  end

  # La page actuelle a les bodyclass classe1 et classe2 ("classe1 classe2")
  # Les différents ancêtres ont les classes home, bodyclass et secondclass
  # -> "page-classe1 page-classe2 ancestor-home ancestor-bodyclass ancestor-secondclass"
  def best_bodyclass
    classes = []
    classes += add_prefix_to_classes(bodyclass.split(' '), 'page') unless bodyclass.blank?
    classes += add_prefix_to_classes(ancestor_classes, 'ancestor') unless ancestor_classes.blank?
    classes.join(' ')
  end

  def siblings
    self.class.unscoped
              .where(parent: parent, university: university, website: website)
              .where.not(id: id)
  end

  # Some special pages can override this method to allow explicit direct connections
  # Example: The Communication::Website::Page::Person special page allows to connect University::Person records directly.
  def self.direct_connection_permitted_about_class
    nil
  end

  # TODO L10N : to remove
  def translate_other_attachments(translation)
    translate_attachment(translation, :shared_image) if shared_image.attached?
  end

  protected

  # ["class1", "class2"], "page" -> ["page-class1", "page-class2"]
  def add_prefix_to_classes(classes, prefix)
    classes.map { |single_class| "#{prefix}-#{single_class}" }
  end

  # ["class1", "class2", "class3 class4"] -> ["class1", "class2", "class3", "class4"]
  def ancestor_classes
    @ancestor_classes ||= ancestors.pluck(:bodyclass)
                                   .compact_blank
                                   .join(' ')
                                   .split(' ')
                                   .compact_blank
  end

  def last_ordered_element
    website.pages.where(parent_id: parent_id).ordered.last
  end

  def abouts_with_page_block
    website.blocks.pages.collect(&:about)
  end

  def touch_elements_if_special_page_in_hierarchy
    # We do not call touch as we don't want to trigger the sync on the connected objects
    descendants_and_self.each do |page|
      if page.type == 'Communication::Website::Page::Person'
        website.connected_people.update_all(updated_at: Time.zone.now)
      elsif page.type == 'Communication::Website::Page::Organization'
        website.connected_organizations.update_all(updated_at: Time.zone.now)
      end
    end
  end
end
