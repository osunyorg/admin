class Admin::Administration::Qualiopi::CriterionsController < Admin::Administration::ApplicationController
  load_and_authorize_resource class: Administration::Qualiopi::Criterion

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Administration::Qualiopi.model_name.human, admin_administration_qualiopi_criterions_path
    if @criterion
      add_breadcrumb @criterion, [:admin, @criterion]
    end
  end

  def criterion_params
    params.require(:features_education_qualiopi_criterion)
          .permit(:number, :name, :description)
  end
end
