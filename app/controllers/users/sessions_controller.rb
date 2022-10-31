class Users::SessionsController < Devise::SessionsController
  include Users::AddContextToRequestParams
  include Users::LayoutChoice

  # DELETE /resource/sign_out
  def destroy
    current_user.invalidate_all_sessions!
    super
  end

end
