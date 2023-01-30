module ServerSetup
  def setup
    sign_in_with_2fa(server_admin)
  end
end