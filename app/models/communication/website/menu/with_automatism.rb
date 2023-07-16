module Communication::Website::Menu::WithAutomatism
  extend ActiveSupport::Concern

  def create_automatic_menu

  end

  def stop_automatism!
    update_column :automatic, false
  end
  
end