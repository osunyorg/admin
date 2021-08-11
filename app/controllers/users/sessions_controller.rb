class Users::SessionsController < Devise::SessionsController
  prepend_before_action :set_university, only: :create

  protected

  def set_university
    return if request.params[:user].nil?
    request.params[:user][:university_id] = current_university.id
  end
end
