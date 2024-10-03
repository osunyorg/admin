class Admin::Education::DiplomasController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Diploma,
                              through: :current_university

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @diplomas = @diplomas.ordered
    breadcrumb
  end

  def show
    @programs = @diploma.programs.ordered.page params[:page]
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @diploma.save
      redirect_to [:admin, @diploma],
                  notice: t('admin.successfully_created_html', model: @diploma.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @diploma.update(diploma_params)
      redirect_to [:admin, @diploma],
                  notice: t('admin.successfully_updated_html', model: @diploma.to_s_in(current_language))
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @diploma.destroy
    redirect_to admin_education_diplomas_url,
                notice: t('admin.successfully_destroyed_html', model: @diploma.to_s_in(current_language))
  end

  private

  def breadcrumb
    super
    add_breadcrumb Education::Diploma.model_name.human(count: 2), admin_education_diplomas_path
    breadcrumb_for @diploma
  end

  def diploma_params
    params.require(:education_diploma)
          .permit(
            :level, :ects, :certification,
            localizations_attributes: [
              :id, :name, :slug, :short_name, :summary, :duration,
              :language_id
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end
end
