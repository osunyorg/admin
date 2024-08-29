class Admin::Administration::Alumni::CohortsController < Admin::Administration::ApplicationController
  load_and_authorize_resource :alumnus,
                              class: University::Person,
                              through: :current_university,
                              through_association: :people,
                              parent: false
  def edit
    breadcrumb
  end

  def update
    if @alumnus.update(cohorts_params)
      redirect_to admin_administration_alumnus_path(@alumnus),
                  notice: t('admin.successfully_updated_html', model: @alumnus.to_s)
    else
      render :edit
      breadcrumb
    end
  end

  private

  def breadcrumb
    super
    add_breadcrumb University::Person::Alumnus.model_name.human(count: 2), admin_administration_alumni_path
    add_breadcrumb @alumnus.to_s_in(current_language), admin_administration_alumnus_path(@alumnus)
    add_breadcrumb Education::Cohort.model_name.human(count: 2)
  end

  def cohorts_params
    params.require(:university_person)
          .permit(cohorts_attributes: [:id, :school_id, :program_id, :year, :_destroy])
          .merge(university_id: current_university.id)
          .tap { |permitted_params|
            permitted_params[:cohorts_attributes].transform_values! do |hash|
              hash.merge(university_id: current_university.id)
            end
          }
  end

end
