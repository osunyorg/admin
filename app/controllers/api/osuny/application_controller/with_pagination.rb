module Api::Osuny::ApplicationController::WithPagination
  extend ActiveSupport::Concern

  DEFAULT_PAGE_SIZE = 10000
  MAX_PAGE_SIZE = 10000

  protected

  def paginate(relation)
    paginated_relation = relation.page(page_num_param).per(per_page_param)
    response.set_header('X-Total-Count', paginated_relation.total_count.to_s)
    response.set_header('X-Total-Pages', paginated_relation.total_pages.to_s)
    paginated_relation
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
