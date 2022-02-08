class Admin::Education::ProgramsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Program,
                              through: :current_university,
                              through_association: :education_programs

  before_action :load_teacher_people, only: [:new, :edit, :create, :update]

  def index
    @programs = @programs.root.ordered
    breadcrumb
  end

  def reorder
    parent_id = params[:parentId].blank? ? nil : params[:parentId]
    ids = params[:ids] || []
    first_program = nil
    ids.each.with_index do |id, index|
      program = current_university.education_programs.find(id)
      first_program = program if index == 0
      program.update(
        parent_id: parent_id,
        position: index + 1,
        skip_websites_categories_callback: true
      )
    end
    first_program.set_websites_categories if first_program
    first_program.sync_with_git if first_program
  end

  def children
    return unless request.xhr?
    @children = @program.children.ordered
  end

  def show
    @roles = @program.university_roles.ordered
    @teacher_involvements = @program.university_person_involvements.includes(:person).ordered_by_name
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
    if @program.save_and_sync
      redirect_to [:admin, @program], notice: t('admin.successfully_created_html', model: @program.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @program.update_and_sync(program_params)
      redirect_to [:admin, @program], notice: t('admin.successfully_updated_html', model: @program.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @program.destroy_and_sync
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
      :prerequisites, :objectives, :duration, :registration, :pedagogy, :content,
      :evaluation, :accessibility, :pricing, :contacts, :opportunities, :other,
      :parent_id, school_ids: [], university_person_involvements_attributes: [:id, :person_id, :description, :position, :_destroy]
    )
  end

  def load_teacher_people
    @teacher_people = current_university.people.teachers.accessible_by(current_ability).ordered
  end
end
