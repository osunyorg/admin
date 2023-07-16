module Communication::Website::Menu::WithAutomatism
  extend ActiveSupport::Concern

  included do 
    scope :automatic, -> { where(automatic: true) }
  end

  def generate_automatically
    begin
      pause_git_sync
      clear_items
      create_items
    ensure
      unpause_git_sync
    end
  end

  def stop_automatism!
    update_column :automatic, false
  end

  protected
  
  def pause_git_sync
    # TODO
  end

  def clear_items
    # TODO est-ce bien de ne pas gérer les dépendances avec un destroy? Effet de bord?
    items.delete_all
  end

  def create_items
    home = website.pages.root.first
    create_items_for_children_of(home)
  end

  def create_items_for_children_of(page, parent_item = nil)
    page.children.ordered.each do |child_page|
      next if child_page.default_menu_identifier != identifier
      create_item_for(child_page, parent_item)
    end
  end

  def create_item_for(page, parent_item = nil)
    item = items.create kind: :page,
                        about: page,
                        title: page.title,
                        position: page.position,
                        website: website,
                        university: university,
                        parent: parent_item
    create_items_for_children_of(page, item)
  end

  def unpause_git_sync
    # TODO
  end
end