class Admin::Research::ResearchersController < Admin::Research::ApplicationController
  load_and_authorize_resource class: Research::Researcher

  def index
    breadcrumb
  end

  def show
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
    if @researcher.save
      redirect_to [:admin, @researcher], notice: "Researcher was successfully created."
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @researcher.update(researcher_params)
      redirect_to [:admin, @researcher], notice: "Researcher was successfully updated."
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @researcher.destroy
    redirect_to admin_research_researchers_url, notice: "Researcher was successfully destroyed."
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Researcher.model_name.human(count: 2), admin_research_researchers_path
    breadcrumb_for @researcher
  end

  def researcher_params
    params.require(:research_researcher).permit(:first_name, :last_name, :biography, :user_id)
  end
end
