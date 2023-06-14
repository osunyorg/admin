module User::WithFavorites
  extend ActiveSupport::Concern

  included do
    has_many :favorites
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
end
