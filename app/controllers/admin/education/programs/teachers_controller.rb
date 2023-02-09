class Admin::Education::Programs::TeachersController < Admin::Education::Programs::ApplicationController
  load_and_authorize_resource :involvement,
                              class: University::Person::Involvement,
                              through: :program,
                              through_association: :university_person_involvements,
                              parent: false

  include Admin::Reorderable

  before_action :get_available_people, except: [:index, :reorder, :destroy]

  def index
    @involvements = @involvements.ordered_by_name
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
    if @involvement.save
      redirect_to admin_education_program_teachers_path(@program), notice: t('admin.successfully_created_html', model: @involvement.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @involvement.update(involvement_params)
      redirect_to admin_education_program_teachers_path(@program), notice: t('admin.successfully_updated_html', model: @involvement.to_s)
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @involvement.destroy
    redirect_back fallback_location: admin_education_program_path(@program), notice: t('admin.successfully_quit_html', model: @involvement.to_s, target: @involvement.target.to_s)
  end

  protected

  def get_available_people
    used_person_ids = @program.university_person_involvements.where.not(id: @involvement.id).pluck(:person_id)
    @available_people = current_university.people
                                          .for_language_id(current_university.default_language_id)
                                          .teachers
                                          .where.not(id: used_person_ids)
                                          .accessible_by(current_ability)
                                          .ordered
  end

  def breadcrumb
    super
    add_breadcrumb Education::Program.human_attribute_name("teachers"), admin_education_program_teachers_path(@program)
    if @involvement
      @involvement.persisted?  ? add_breadcrumb(@involvement)
                               : add_breadcrumb(t('create'))
    end
  end

  def involvement_params
    params.require(:university_person_involvement)
          .permit(:description, :position, :person_id)
          .merge(university_id: @program.university_id, kind: :teacher)
  end

  def model
    University::Person::Involvement
  end
end
