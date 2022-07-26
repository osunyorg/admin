class Users::SessionsController < Devise::SessionsController
  include Users::AddUniversityToRequestParams

  # DELETE /resource/sign_out
  def destroy
    current_user.invalidate_all_sessions!
    super
  end
  
end
