class Users::TwoFactorAuthenticationController < Devise::TwoFactorAuthenticationController
  include WithLocale
end
