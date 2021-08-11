class Adminserver::UniversitiesController < Adminserver::ApplicationController
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
    breadcrumb
    respond_to do |format|
      if @university.save
        format.html { redirect_to [:adminserver, @university], notice: "University was successfully created." }
        format.json { render :show, status: :created, location: [:adminserver, @university] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    breadcrumb
    respond_to do |format|
      if @university.update(university_params)
        format.html { redirect_to [:adminserver, @university], notice: "University was successfully updated." }
        format.json { render :show, status: :ok, location: [:adminserver, @university] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @university.destroy
    respond_to do |format|
      format.html { redirect_to adminserver_universities_url, notice: "University was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University.model_name.human(count: 2), adminserver_universities_path
    if @university
      if @university.persisted?
        add_breadcrumb @university, [:adminserver, @university]
      else
        add_breadcrumb 'Créer'
      end
    end
  end

  def university_params
    params.require(:university).permit(:name, :address, :zipcode, :city, :country, :private, :identifier)
  end
end
