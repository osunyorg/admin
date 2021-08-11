class Admin::Features::Education::Qualiopi::IndicatorsController < Admin::Features::Education::ApplicationController
  load_and_authorize_resource class: Features::Education::Qualiopi::Indicator

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Features::Education::Qualiopi.model_name.human(count: 2), admin_features_education_qualiopi_criterions_path
    if @indicator
      add_breadcrumb @indicator.criterion, [:admin, @indicator.criterion]
      add_breadcrumb @indicator, [:admin, @indicator]
    end
  end

  def indicator_params
    params.require(:features_education_qualiopi_indicator)
          .permit(:criterion_id, :number, :name, :level_expected, :proof, :requirement, :non_conformity)
  end
end
