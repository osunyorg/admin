module Admin::Translatable
  extend ActiveSupport::Concern

  included do

    def translate
      byebug
    end

    protected

    def translatable_params(model_name, attribute_names, default_language_id, languages_count)
      attribute_names << :language_id if languages_count > 1
      permitted_params = params.require(model_name).permit(attribute_names).merge(university_id: current_university.id)
      permitted_params.merge!(language_id: default_language_id) if languages_count == 1
      permitted_params
    end
  end

end
