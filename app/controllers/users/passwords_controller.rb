class Users::PasswordsController < Devise::PasswordsController
  include WithLocale
  include Users::AddUniversityToRequestParams
end
