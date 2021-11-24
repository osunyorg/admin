class Admin::Education::ProgramsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Program

  def index
    @programs = current_university.education_programs.root.ordered
    breadcrumb
  end

  def reorder
    parent_id = params[:parentId].blank? ? nil : params[:parentId]
    ids = params[:ids] || []
    website_ids = []
    ids.each.with_index do |id, index|
      program = current_university.education_programs.find(id)
      program.update(
        parent_id: parent_id,
        position: index + 1,
        skip_websites_categories_callback: true
      )
      website_ids.concat(program.website_ids)
    end
    current_university.communication_websites.where(id: website_ids.uniq).each do |website|
      website.set_programs_categories!
    end
  end

  def children
    return unless request.xhr?
    @program = current_university.education_programs.find(params[:id])
    @children = @program.children.ordered
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
    @program.university = current_university
    if @program.save
      redirect_to [:admin, @program], notice: t('admin.successfully_created_html', model: @program.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @program.update(program_params)
      redirect_to [:admin, @program], notice: t('admin.successfully_updated_html', model: @program.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @program.destroy
    redirect_to admin_education_programs_url, notice: t('admin.successfully_destroyed_html', model: @program.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::Program.model_name.human(count: 2), admin_education_programs_path
    breadcrumb_for @program
  end

  def program_params
    params.require(:education_program)
          .permit(:name, :level, :capacity, :ects, :continuing,
            :prerequisites, :objectives, :duration, :registration, :pedagogy,
            :evaluation, :accessibility, :pricing, :contacts, :opportunities, :other, :parent_id, school_ids: [], teacher_ids: [])
  end
end
