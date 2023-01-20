module ExtranetSetup
  def setup
    host! default_extranet.host
    sign_in_with_2fa(alumnus)
  end
end