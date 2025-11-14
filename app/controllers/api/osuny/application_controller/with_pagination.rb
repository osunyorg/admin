module Api::Osuny::ApplicationController::WithPagination
  extend ActiveSupport::Concern

  protected

  def page_num_param
    @page_num_param ||= params[:page_num].to_i > 0 ? params[:page_num].to_i : 1
  end

  def per_page_param
    @per_page_param ||= begin
      per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 25
      [per_page, 100].min
    end
  end

end
