class Admin::UniversitiesController < Admin::ApplicationController
  load_and_authorize_resource

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
    add_breadcrumb 'Modifier'
  end

  def create
    if @university.save
      redirect_to [:admin, @university], notice: "University was successfully created."
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @university.update(university_params)
      redirect_to [:admin, @university], notice: "University was successfully updated."
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @university.destroy
    redirect_to admin_universities_url, notice: "University was successfully destroyed."
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University.model_name.human(count: 2), admin_universities_path
    if @university
      if @university.persisted?
        add_breadcrumb @university, [:admin, @university]
      else
        add_breadcrumb 'Créer'
      end
    end
  end

  def university_params
    params.require(:university).permit(:name, :address, :zipcode, :city, :country, :private, :identifier)
  end
end
