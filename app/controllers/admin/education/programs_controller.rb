class Admin::Education::ProgramsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Program,
                              through: :current_university,
                              through_association: :education_programs

  def index
    @programs = @programs.root.ordered
    breadcrumb
  end

  def reorder
    parent_id = params[:parentId].blank? ? nil : params[:parentId]
    ids = params[:ids] || []
    programs = []
    website_ids = []
    ids.each.with_index do |id, index|
      program = current_university.education_programs.find(id)
      programs << program
      website_ids.concat(program.list_of_websites.map(&:id))
      programs.concat(program.descendents) if parent_id != program.parent_id
      program.update(
        parent_id: parent_id,
        position: index + 1,
        skip_github_publication: true
      )
    end
    website_ids.uniq.each do |website_id|
      github = Github.with_website current_university.communication_websites.find(website_id)
      github.send_batch_to_website(programs, message: '[Program] Reorder programs.')
    end
  end

  def children
    return unless request.xhr?
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
    params.require(:education_program).permit(
      :name, :slug, :level, :capacity, :ects, :continuing, :description, :published,
      :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt,
      :prerequisites, :objectives, :duration, :registration, :pedagogy,
      :evaluation, :accessibility, :pricing, :contacts, :opportunities, :other,
      :parent_id, school_ids: [], teacher_ids: [],
      members_attributes: [:id, :role, :member_id, :_destroy]
    )
  end
end
