class Admin::Education::Programs::RolesController < Admin::Education::Programs::ApplicationController
  load_and_authorize_resource class: University::Role, through: :program, through_association: :university_roles

  include Admin::Reorderable
  include Admin::Localizable

  before_action :load_administration_people, only: [:new, :edit, :create, :update]

  def index
    @roles = @roles.ordered
    breadcrumb
  end

  def show
    @involvements = @role.involvements.ordered
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
    if @role.save
      redirect_to admin_education_program_role_path(@role), notice: t('admin.successfully_created_html', model: @role.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @role.update(role_params)
      redirect_to admin_education_program_role_path(@role), notice: t('admin.successfully_updated_html', model: @role.to_s_in(current_language))
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @role.destroy
    redirect_to admin_education_program_path(@program), notice: t('admin.successfully_destroyed_html', model: @role.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Role.model_name.human(count: 2), admin_education_program_roles_path(@program)
    if @role
      @role.persisted?  ? add_breadcrumb(@role.to_s_in(current_language), admin_education_program_role_path(@role, { program_id: @program.id }))
                        : add_breadcrumb(t('create'))
    end
  end

  def role_params
    params.require(:university_role)
          .permit(
            localizations_attributes: [
              :id, :description, :language_id
            ],
            involvements_attributes: [
              :id, :person_id, :position, :_destroy,
              localizations_attributes: [
                :id, :language_id
              ]
            ]
          )
          .merge(
            target: @program,
            university_id: @program.university_id
          )
  end

  def model
    University::Role
  end

  def load_administration_people
    @administration_people =  current_university.people
                                                .administration
                                                .accessible_by(current_ability)
                                                .ordered(current_language)
  end

  # Overriding the method from Admin::Localizable to handle the edit path
  def redirect_if_not_localized
    return if @l10n.present?
    @l10n = resource.localize_in!(current_language)
    redirect_to edit_admin_education_program_role_path(@role)
  end
end
