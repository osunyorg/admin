class Admin::Features::Education::ProgramsController < Admin::Features::Education::ApplicationController
  load_and_authorize_resource class: Features::Education::Program

  def index
    @programs = current_university.features_education_programs
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
    @program.university = current_university
    if @program.save
      redirect_to [:admin, @program], notice: "Program was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @program.update(program_params)
      redirect_to [:admin, @program], notice: "Program was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @program.destroy
    redirect_to admin_features_education_programs_url, notice: "Program was successfully destroyed."
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Features::Education::Program.model_name.human(count: 2), admin_features_education_programs_path
    breadcrumb_for @program
  end

  def program_params
    params.require(:features_education_program)
          .permit(:name, :level, :capacity, :ects, :continuing,
            :prerequisites, :objectives, :duration, :registration, :pedagogy,
            :evaluation, :accessibility, :pricing, :contacts)
  end
end
