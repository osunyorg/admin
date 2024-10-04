class Admin::Education::ProgramsController < Admin::Education::Programs::ApplicationController
  load_and_authorize_resource class: Education::Program,
                              through: :current_university,
                              through_association: :education_programs

  before_action :load_teacher_people, only: [:new, :edit, :create, :update]

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @programs = @programs.filter_by(params[:filters], current_language)
                         .ordered_by_name(current_language)
                         .page(params[:page])
    @feature_nav = 'navigation/admin/education/programs'
    breadcrumb
  end

  def tree
    @programs = @programs.root.ordered
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
    @preview = true
    breadcrumb
  end

  def preview
    @website = @program.websites&.first
    render layout: 'admin/layouts/preview'
  end

  def new
    @categories = categories
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @l10n.add_photo_import params[:photo_import]
    if @program.save
      redirect_to [:admin, @program],
                  notice: t('admin.successfully_created_html', model: @program.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @l10n.add_photo_import params[:photo_import] if params.has_key?(:photo_import)
    load_part
    if @program.update(program_params)
      redirect_to after_update_path,
                  notice: t('admin.successfully_updated_html', model: @program.to_s_in(current_language))
    else
      @categories = categories
      render_invalid_update
    end
  end

  def destroy
    @program.destroy
    redirect_to admin_education_programs_url,
                notice: t('admin.successfully_destroyed_html', model: @program.to_s_in(current_language))
  end

  protected

  def load_part
    part_from_params = params.dig('education_program', 'part')
    @part = part_from_params if ['admission', 'certification', 'pedagogy', 'presentation', 'results'].include?(part_from_params)
  end

  def after_update_path
    @part.present?  ? public_send("#{@part}_admin_education_program_path", @program)
                    : admin_education_program_path(@program)
  end

  def render_invalid_update
    if @part.present?
      breadcrumb
      add_breadcrumb  t("education.program.parts.#{@part}.label"),
                      public_send("#{@part}_admin_education_program_path", id: @program, program_id: nil)
      add_breadcrumb  t('edit')
      render "admin/education/programs/parts/edit_#{@part}", status: :unprocessable_entity
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def categories
    current_university.program_categories
                      .ordered
  end

  def program_params
    params.require(:education_program)
          .permit(
            :bodyclass, :capacity, :continuing, :initial, :apprenticeship, :qualiopi_certified,
            :parent_id, :diploma_id, school_ids: [], category_ids: [],
            university_person_involvements_attributes: [
              :id, :person_id, :university_id, :position, :_destroy,
              localizations_attributes: [:id, :description, :language_id]
            ],
            localizations_attributes: [
              :id, :language_id,
              :name, :short_name, :slug, :url,
              :meta_description, :summary, :published,
              :qualiopi_text,
              :logo, :logo_delete,
              :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
              :shared_image, :shared_image_delete,
              :prerequisites, :objectives, :presentation, :registration, :pedagogy, :content, :registration_url,
              :evaluation, :accessibility, :contacts, :opportunities, :results, :other, :main_information,
              :pricing, :pricing_apprenticeship, :pricing_continuing, :pricing_initial, :duration,
              :downloadable_summary, :downloadable_summary_delete,
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end

  def load_teacher_people
    @teacher_people = current_university.people
                                        .teachers
                                        .accessible_by(current_ability)
                                        .ordered(current_language)
  end
end
