module User::WithFavorites
  extend ActiveSupport::Concern

  included do
    has_many :favorites, dependent: :destroy
    after_save :autoset_favorites
  end

  def add_favorite(about)
    favorites_for(about).first_or_create
  end

  def remove_favorite(about)
    favorites_for(about).destroy_all
  end

  def favorite?(about)
    favorites_for(about).any?
  end

  protected

  def favorites_for(about)
    favorites.where(about_id: about.id, about_type: about.class.polymorphic_name)
  end

  def autoset_favorites
    if saved_change_to_role? && website_manager? && favorites.none?
      websites_to_manage.each do |website|
        add_favorite(website)
      end
    end
  end
end
