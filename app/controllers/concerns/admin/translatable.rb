module Admin::Translatable
  extend ActiveSupport::Concern

  included do

    def translate
      raise NotImplementedError
    end

    protected

    def translatable_params(model_name, attribute_names)
      params.require(model_name).permit(attribute_names).merge(
        university_id: current_university.id,
        language_id: current_website_language.id
      )
    end
  end

end
