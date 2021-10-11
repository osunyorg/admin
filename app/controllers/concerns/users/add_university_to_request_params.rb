module Users::AddUniversityToRequestParams
  extend ActiveSupport::Concern

  included do
    prepend_before_action :add_university_to_request_params, only: :create
  end

  protected

  def add_brand_to_request_params
    # inject university_id in users params submitted
    request.params[:user][:university_id] = current_university.id unless request.params[:user].nil?
  end
end
