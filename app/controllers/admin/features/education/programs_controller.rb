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
    add_breadcrumb 'Modifier'
  end

  def create
    @program.university = current_university
    respond_to do |format|
      if @program.save
        format.html { redirect_to [:admin, @program], notice: "Program was successfully created." }
        format.json { render :show, status: :created, location: @program }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to [:admin, @program], notice: "Program was successfully updated." }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @program.destroy
    respond_to do |format|
      format.html { redirect_to admin_features_education_programs_url, notice: "Program was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Features::Education::Program.model_name.human(count: 2), admin_features_education_programs_path
    if @program
      if @program.persisted?
        add_breadcrumb @program, [:admin, @program]
      else
        add_breadcrumb 'Créer'
      end
    end
  end

  def program_params
    params.require(:features_education_program)
          .permit(:name, :level, :capacity, :ects, :continuing,
            :prerequisites, :objectives, :duration, :registration, :pedagogy,
            :evaluation, :accessibility, :pricing, :contacts)
  end
end
