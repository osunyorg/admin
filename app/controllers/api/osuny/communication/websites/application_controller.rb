class Api::Osuny::Communication::Websites::ApplicationController < Api::Osuny::ApplicationController
  before_action :load_website

  before_action :load_migration_identifier, only: [:create, :update]
  before_action :ensure_migration_identifier_is_available, only: :create
  before_action :ensure_same_migration_identifier, only: :update

  protected

  def load_website
    @website = current_university.websites.find params[:website_id]
  end

  def website
    @website
  end

  def load_migration_identifier
    raise NoMethodError, "You must implement the `load_migration_identifier` method in #{self.class.name}"
  end

  def ensure_migration_identifier_is_available
    raise NoMethodError, "You must implement the `ensure_migration_identifier_is_available` method in #{self.class.name}"
  end

  def ensure_same_migration_identifier
    raise NoMethodError, "You must implement the `ensure_same_migration_identifier` method in #{self.class.name}"
  end

end
