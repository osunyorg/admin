module Users::AddContextToRequestParams
  extend ActiveSupport::Concern

  included do
    prepend_before_action :add_context_to_request_params, only: :create
  end

  protected

  def add_context_to_request_params
    # inject university_id & context in users params submitted
    return if request.params[:user].nil?
    request.params[:user][:university_id] = current_university.id
    request.params[:user][:registration_context] = current_context
  end
end
