class Admin::University::People::Experiences::ImportsController < Admin::University::ApplicationController
  load_and_authorize_resource class: Import,
                              through: :current_university,
                              through_association: :imports

  def index
    @imports = @imports.kind_people_experiences
                       .filter_by(params[:filters], current_language)
                       .ordered(current_language)
                       .page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
    render 'admin/imports/show'
  end

  def new
    breadcrumb
  end

  def create
    @import.kind = :people_experiences
    @import.user = current_user
    @import.language = current_language
    if @import.save
      redirect_to admin_university_people_experiences_import_path(@import),
                  notice: t('admin.successfully_created_html', model: @import.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::Person.model_name.human(count: 2),
                    admin_university_people_path
    add_breadcrumb  t('university.person.experiences.title'),
                    admin_university_people_experiences_imports_path
    return unless @import
    @import.persisted?  ? add_breadcrumb(@import, admin_university_people_experiences_import_path(@import))
                        : add_breadcrumb(t('create'))
  end

  def import_params
    params.require(:import)
          .permit(:file)
          .merge(
            university_id: current_university.id
          )
  end
end
