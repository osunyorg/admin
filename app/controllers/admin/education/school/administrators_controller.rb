class Admin::Education::School::AdministratorsController < Admin::Education::School::ApplicationController
  load_and_authorize_resource class: Education::School::Administrator, through: :school

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @administrator.save
      redirect_to admin_education_school_path(@school), notice: t('admin.successfully_created_html', model: @administrator.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @administrator.update(administrator_params)
      redirect_to admin_education_school_path(@school), notice: t('admin.successfully_updated_html', model: @administrator.to_s)
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @administrator.destroy
    redirect_to admin_education_school_path(@school), notice: t('admin.successfully_destroyed_html', model: @administrator.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::School::Administrator.model_name.human(count: 2)
    breadcrumb_for @administrator
  end

  def administrator_params
    params.require(:education_school_administrator)
          .permit(:description, :person_id)
          .merge(school_id: @school.id)
  end
end
