class Admin::Education::ProgramsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Program,
                              through: :current_university,
                              through_association: :education_programs

  before_action :load_teacher_people, only: [:new, :edit, :create, :update]

  include Admin::Translatable

  has_scope :for_search_term
  has_scope :for_diploma
  has_scope :for_school
  has_scope :for_publication

  def index
    @programs = apply_scopes(@programs)
                  .in_closest_language_id(current_language.id)
                  .ordered_by_name
                  .page(params[:page])
    breadcrumb
  end

  def tree
    @programs = @programs.root
                         .in_closest_language_id(current_language.id)
                         .ordered
    breadcrumb
    add_breadcrumb t('.title')
  end

  def reorder
    parent_id = params[:parentId].blank? ? nil : params[:parentId]
    old_parent_id = params[:oldParentId].blank? ? nil : params[:oldParentId]
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      program = current_university.education_programs.find(id)
      program.update_columns  parent_id: parent_id,
                              position: index + 1
    end
    if old_parent_id
      old_parent = current_university.education_programs.find(old_parent_id)
      old_parent.set_websites_categories
      old_parent.touch
    end
    program = current_university.education_programs.find(params[:itemId])
    program.set_websites_categories
    program.touch
  end

  def children
    return unless request.xhr?
    @children = @program.children.ordered
  end

  def show
    @roles = @program.university_roles.ordered
    @teacher_involvements = @program.university_person_involvements.includes(:person).ordered_by_name
    @preview = true
    breadcrumb
  end

  def static
    @about = @program
    @website = @program.websites&.first
    render_as_plain_text
  end

  def preview
    @website = @program.websites&.first
    render layout: 'admin/layouts/preview'
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @program.language_id = current_language.id
    @program.add_photo_import params[:photo_import]
    if @program.save
      redirect_to [:admin, @program], notice: t('admin.successfully_created_html', model: @program.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @program.add_photo_import params[:photo_import]
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
          .permit(
            :name, :short_name, :slug, :url, :bodyclass,
            :meta_description, :summary, :published,
            :capacity, :continuing, :initial, :apprenticeship, 
            :qualiopi_certified, :qualiopi_text,
            :logo, :logo_delete, 
            :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
            :shared_image, :shared_image_delete,
            :prerequisites, :objectives, :presentation, :registration, :pedagogy, :content, :registration_url,
            :evaluation, :accessibility, :contacts, :opportunities, :results, :other, :main_information,
            :pricing, :pricing_apprenticeship, :pricing_continuing, :pricing_initial, :duration,
            :downloadable_summary, :downloadable_summary_delete,
            :parent_id, :diploma_id, school_ids: [],
            university_person_involvements_attributes: [:id, :person_id, :description, :position, :_destroy]
          )
          .merge(
            university_id: current_university.id
          )
  end

  def load_teacher_people
    @teacher_people = current_university.people
                                        .for_language_id(current_university.default_language_id)
                                        .teachers
                                        .accessible_by(current_ability)
                                        .ordered
  end
end
