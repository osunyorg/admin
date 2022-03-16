class Admin::University::Person::Alumnus::ImportsController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Person::Alumnus::Import,
                              through: :current_university,
                              through_association: :person_alumnus_imports

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def create
    @import.university = current_university
    @import.user = current_user
    if @import.save
      redirect_to [:admin, @import], notice: "Import was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::Person::Alumnus.model_name.human(count: 2),
                    admin_university_person_alumni_path
    add_breadcrumb  University::Person::Alumnus::Import.model_name.human(count: 2),
                    admin_university_person_alumnus_imports_path
    breadcrumb_for  @import
  end

  def import_params
    params.require(:university_person_alumnus_import)
          .permit(:file)
  end
end
