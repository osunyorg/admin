class Extranet::Alumni::ApplicationController < Extranet::ApplicationController
  before_action :redirect_if_feature_disabled

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person::Alumnus.model_name.human(count: 2), alumni_root_path
  end

  def redirect_if_feature_disabled
    redirect_to extranet_root_path unless current_extranet.feature_alumni?
  end
end