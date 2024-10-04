module Admin::Localizable
  extend ActiveSupport::Concern

  included do
    before_action :build_localization,
                  only: :new

    before_action :load_invalid_localization,
                  only: :create

    before_action :load_localization,
                  :redirect_if_not_localized,
                  only: [:show, :edit, :static, :publish, :preview]
  end

  protected

  # On new, we need to init the localization
  def build_localization
    @l10n = resource.localizations.build(language: current_language)
  end

  # On create, when there's an error, we need to get unsaved localization from association
  def load_invalid_localization
    @l10n = resource.localizations.detect { |l10n| l10n.language_id == current_language.id }
  end

  # On every other action, we need to load the localization
  def load_localization
    @l10n = resource.localization_for(current_language)
  end

  def redirect_if_not_localized
    return if @l10n.present?

    if resource_is_website_direct_object? && !resource.website.localized_in?(current_language)
      redirect_to_confirm_localization(resource.website)
    elsif resource_is_extranet_object? && !resource.extranet.localized_in?(current_language)
      redirect_to_confirm_localization(resource.extranet)
    else
      localize_resource_and_redirect_to_edit
    end
  end

  def resource_is_website_direct_object?
    resource.try(:is_direct_object?) && !resource.is_a?(Communication::Website)
  end

  def resource_is_extranet_object?
    resource.respond_to?(:extranet) && !resource.is_a?(Communication::Extranet)
  end

  def redirect_to_confirm_localization(parent_resource)
    redirect_to [:confirm_localization, :admin, parent_resource, { about: resource.to_gid.to_s }]
  end

  def localize_resource_and_redirect_to_edit
    @l10n = resource.localize_in!(current_language)
    edit_path_method = "edit_admin_#{resource.class.base_class.to_s.parameterize.underscore}_path"
    redirect_to public_send(edit_path_method, id: resource.id)
  end

  def resource_name
    self.class.to_s.remove("Controller").demodulize.singularize.underscore
  end

  def resource
    instance_variable_get("@#{resource_name}")
  end
end
