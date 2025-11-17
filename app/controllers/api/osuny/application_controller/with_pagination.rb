module Api::Osuny::ApplicationController::WithPagination
  extend ActiveSupport::Concern

  DEFAULT_PAGE_SIZE = 500
  MAX_PAGE_SIZE = 1000

  protected

  def page_num_param
    @page_num_param ||= params[:page_num].to_i > 0 ? params[:page_num].to_i : 1
  end

  def per_page_param
    @per_page_param ||= begin
      per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : DEFAULT_PAGE_SIZE
      [per_page, MAX_PAGE_SIZE].min
    end
  end

end
