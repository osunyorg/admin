class Admin::University::Alumni::ExperiencesController < Admin::University::ApplicationController
  load_and_authorize_resource :alumnus,
                              class: University::Person,
                              through: :current_university,
                              through_association: :people,
                              parent: false
  def edit
    breadcrumb
  end

  def update
    if @alumnus.update(experiences_params)
      redirect_to admin_university_alumnus_path(@alumnus),
                  notice: t('admin.successfully_updated_html', model: @alumnus.to_s)
    else
      render :edit
      breadcrumb
    end
  end

  private

  def breadcrumb
    super
    add_breadcrumb  University::Person::Alumnus.model_name.human(count: 2),
                    admin_university_alumni_path
    add_breadcrumb @alumnus, admin_university_alumnus_path(@alumnus)
    add_breadcrumb University::Person::Experience.model_name.human(count: 2)
  end

  def experiences_params
    params.require(:university_person)
          .permit(experiences_attributes: [:id, :organization_id, :university_id, :from_year, :to_year, :_destroy])
  end

end
