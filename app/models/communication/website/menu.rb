# == Schema Information
#
# Table name: communication_website_menus
#
#  id                       :uuid             not null, primary key
#  automatic                :boolean          default(TRUE)
#  identifier               :string
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  original_id              :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_comm_website_menus_on_communication_website_id  (communication_website_id)
#  index_communication_website_menus_on_language_id    (language_id)
#  index_communication_website_menus_on_original_id    (original_id)
#  index_communication_website_menus_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2901ebb799  (original_id => communication_website_menus.id)
#  fk_rails_4d43d36541  (language_id => languages.id)
#  fk_rails_8d6227916e  (university_id => universities.id)
#  fk_rails_dcc7198fc5  (communication_website_id => communication_websites.id)
#
class Communication::Website::Menu < ApplicationRecord
  include AsDirectObject
  include Sanitizable
  include WithTranslations
  include WithUniversity

  has_many :items, class_name: 'Communication::Website::Menu::Item', dependent: :destroy

  validates :title, :identifier, presence: true
  validates :identifier, uniqueness: { scope: [:communication_website_id, :language_id] }

  scope :ordered, -> { order(created_at: :asc) }

  def to_s
    "#{title}"
  end

  def git_path(website)
    "data/menus/#{language.iso_code}/#{identifier}.yml"
  end

  def template_static
    "admin/communication/websites/menus/static"
  end

  def translate_additional_data!(translation)
    items.root.ordered.each { |item| translate_menu_item!(item, translation) }
  end

  def translate_menu_item!(item, menu_translation, parent_translation = nil)
    item_translation = item.dup
    item_translation.menu = menu_translation
    item_translation.parent = parent_translation

    # TODO : I18n
    # For now, only pages, posts, categories are handled.
    # We need to translate programs, diplomas, volumes and papers
    set_item_translation_attributes(item_translation, item, menu_translation)

    # If no translation and no children to translate, translation won't be save, as about is nil and kind requires one.
    if item_translation.save
      item.children.ordered.each do |child|
        translate_menu_item!(child, menu_translation, item_translation)
      end
    end
  end

  def set_item_translation_attributes(item_translation, item, menu_translation)
    return unless item.about.present? && item.about.respond_to?(:translation_for)
    # Search for the target translation based on the given language.
    item_translation.about = item.about.translation_for(menu_translation.language)
    # If no target translation found, convert to a blank menu item if item has children.
    item_translation.kind = 'blank' if item_translation.about.nil? && item.children.any?
  end
end
