module Api::Osuny::ApplicationController::WithPagination
  extend ActiveSupport::Concern

  DEFAULT_PAGE_SIZE = 500
  MAX_PAGE_SIZE = 1000

  protected

  def paginate(relation)
    relation.page(page_num_param)
            .per(per_page_param)
  end

  def page_num_param
    @page_num_param ||= params.fetch(:page_num, 1).to_i
  end

  def per_page_param
    @per_page_param ||= begin
      per_page = params.fetch(:per_page, DEFAULT_PAGE_SIZE).to_i
      [per_page, MAX_PAGE_SIZE].min
    end
  end

end
