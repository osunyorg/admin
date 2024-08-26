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
  IDENTIFIER_MAX_LENGTH = 100
  DEFAULT_MENUS_IDENTIFIERS = ['primary', 'legal', 'social'].freeze

  include AsDirectObject
  include Initials
  include Sanitizable
  include WithAutomatism
  include WithGitFiles
  include WithUniversity

  belongs_to :language
  has_many :items, class_name: 'Communication::Website::Menu::Item', dependent: :destroy

  # TODO L10N : Deprecated
  belongs_to  :original,
              class_name: "Communication::Website::Menu",
              optional: true
  has_many    :translations,
              class_name: "Communication::Website::Menu",
              foreign_key: :original_id,
              dependent: :destroy
  # /Deprecated

  validates :title, :identifier, presence: true
  validates :identifier,  length: { maximum: IDENTIFIER_MAX_LENGTH },
                          uniqueness: { scope: [:communication_website_id, :language_id] }

  after_create :sync_in_all_website_languages

  scope :ordered, -> { order(created_at: :asc) }
  scope :for_identifier, -> (identifier) { where(identifier: identifier) }
  scope :for_language, -> (language) { where(language_id: language.id) }
  scope :in_languages, -> (language_ids) { where(language_id: language_ids) }

  def self.menu_title_from_locales(identifier, language)
    key = "communication.website.menus.default_title.#{identifier}"
    locale = language.iso_code
    I18n.exists?(key, locale) ? I18n.t(key, locale: locale) : ''
  end

  def to_s
    "#{title}"
  end

  def git_path(website)
    "data/menus/#{language.iso_code}/#{identifier}.yml"
  end

  def template_static
    "admin/communication/websites/menus/static"
  end

  # TODO L10N : remove
  # Override from Translatable
  def translate_relations!(translation)
    items.root.ordered.each { |item| translate_menu_item!(item, translation) }
  end

  def translate_menu_item!(item, menu_translation, parent_translation = nil)
    item_translation = item.dup
    item_translation.menu = menu_translation
    item_translation.parent = parent_translation

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
  # END TODO L10N



  private

  def sync_in_all_website_languages
    # Default menus are handled in Communication::Website::WithMenus
    return if DEFAULT_MENUS_IDENTIFIERS.include?(identifier)
    website.languages.where.not(id: language_id).each do |new_language|
      new_menu = self.dup
      new_menu.language = new_language
      new_menu.save
    end
  end


end
