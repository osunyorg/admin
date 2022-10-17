class Users::TwoFactorAuthenticationController < Devise::TwoFactorAuthenticationController
  include Users::LayoutChoice
  
end
