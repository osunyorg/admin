module WithMenuItemTarget
  extend ActiveSupport::Concern

  included do
    has_many   :menu_items,
               as: :about,
               class_name: 'Communication::Website::Menu::Item',
               dependent: :destroy

    has_many   :menus,
               -> { distinct },
               through: :menu_items,
               class_name: 'Communication::Website::Menu'

  end
end
