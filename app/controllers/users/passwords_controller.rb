class Users::PasswordsController < Devise::PasswordsController
  include Users::AddUniversityToRequestParams
end
