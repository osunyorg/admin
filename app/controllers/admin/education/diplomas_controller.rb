class Admin::Education::DiplomasController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Diploma,
                              through: :current_university

  def index
    breadcrumb
  end

  def show
    @programs = @diploma.programs.ordered.page params[:page]
    breadcrumb
  end

  def static
    @about = @diploma
    @website = @diploma.websites&.first
    render layout: false
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @diploma.university = current_university
    if @diploma.save
      redirect_to [:admin, @diploma],
                  notice: t('admin.successfully_created_html', model: @diploma.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @diploma.update(diploma_params)
      redirect_to [:admin, @diploma],
                  notice: t('admin.successfully_updated_html', model: @diploma.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @diploma.destroy
    redirect_to admin_education_diplomas_url,
                notice: t('admin.successfully_destroyed_html', model: @diploma.to_s)
  end

  private

  def breadcrumb
    super
    add_breadcrumb Education::Diploma.model_name.human(count: 2), admin_education_diplomas_path
    breadcrumb_for @diploma
  end

  def diploma_params
    params.require(:education_diploma)
          .permit(:name, :short_name, :summary, :level, :ects, :duration)
  end
end
