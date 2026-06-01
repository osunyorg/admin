module Communication::Website::Page::WithAutomaticMenus
  extend ActiveSupport::Concern

  included do
    after_save :generate_automatic_menus
    after_restore :generate_automatic_menus
  end

  protected

  def generate_automatic_menus
    return if Duplicable.in_progress?
    website.generate_automatic_menus_for_identifier(default_menu_identifier)
  end

  # Called by Duplicable#finalize_duplication once the duplication transaction
  # has been committed, so that automatic menus are regenerated once instead
  # of once per intermediate save during the duplication.
  def generate_automatic_menus_after_duplication
    website.generate_automatic_menus_for_identifier(default_menu_identifier)
  end
end
