module ExtranetSetup
  def setup
    host! "extranet.osuny.test"
    sign_in_with_2fa(alumnus)
  end
end