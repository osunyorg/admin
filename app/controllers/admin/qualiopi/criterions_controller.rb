class Admin::Qualiopi::CriterionsController < Admin::ApplicationController
  load_and_authorize_resource class: Qualiopi::Criterion

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
    respond_to do |format|
      if @criterion.save
        format.html { redirect_to [:admin, @criterion], notice: "Criterion was successfully created." }
        format.json { render :show, status: :created, location: [:admin, @criterion] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @criterion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @criterion.update(criterion_params)
        format.html { redirect_to [:admin, @criterion], notice: "Criterion was successfully updated." }
        format.json { render :show, status: :ok, location: [:admin, @criterion] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @criterion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @criterion.destroy
    respond_to do |format|
      format.html { redirect_to admin_qualiopi_criterions_url, notice: "Criterion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Qualiopi.model_name.human(count: 2), admin_qualiopi_root_path
    if @criterion
      if @criterion.persisted?
        add_breadcrumb @criterion, [:admin, @criterion]
      else
        add_breadcrumb 'Créer'
      end
    end
  end

  def criterion_params
    params.require(:qualiopi_criterion).permit(:number, :name, :description)
  end
end
