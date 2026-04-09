module Api::Osuny::HasResource
  extend ActiveSupport::Concern

  included do
    before_action :load_resource, only: [:show, :update, :destroy]
  end

  protected
  
  def load_resource
    raise NoMethodError, "You must implement the `load_resource` method in #{self.class.name}"
  end

end