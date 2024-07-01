module Admin::Localizable
  extend ActiveSupport::Concern

  included do
    before_action :load_localization, 
                  :redirect_if_not_localized, 
                  only: [:show, :edit, :update]
  end

  protected

  def load_localization
    @l10n = resource.localization_for(current_language)
  end

  def redirect_if_not_localized
    return if @l10n.present?
    @l10n = resource.localize_in!(current_language)
    redirect_to [:edit, :admin, resource]
  end

  
  def resource_name
    self.class.to_s.remove("Controller").demodulize.singularize.underscore
  end

  def resource
    instance_variable_get("@#{resource_name}")
  end
end
