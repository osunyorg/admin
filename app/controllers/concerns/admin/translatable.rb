module Admin::Translatable
  extend ActiveSupport::Concern

  included do
    before_action :check_or_redirect_translatable_resource, only: [:show, :edit, :update, :destroy]

    protected

    # If we don't have a website, it will not work

    def translatable_params(model_name, attribute_names)
      params.require(model_name).permit(attribute_names).merge(
        university_id: current_university.id,
        language_id: current_website_language.id
      )
    end

    def check_or_redirect_translatable_resource
      # Early return if language is correct
      return if resource.language_id == current_website_language.id
      # Look up for translation from resource
      translation = resource.translation_for(current_website_language)
      # If not found, translate the current resource (with blocks and all) for given language
      translation ||= resource.translate!(current_website_language)
      # Redirect to the translation
      if ['edit', 'update'].include?(action_name)
        # Safety net on update action if called on wrong language
        redirect_to [:edit, :admin, translation.becomes(translation.class.base_class)]
      else
        # Safety net on destroy action if called on wrong language
        redirect_to [:admin, translation.becomes(translation.class.base_class)]
      end
    end

    def resource_name
      self.class.to_s.remove("Controller").demodulize.singularize.underscore
    end

    def resource
      instance_variable_get("@#{resource_name}")
    end
  end

end
