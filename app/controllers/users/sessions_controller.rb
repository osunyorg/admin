class Users::SessionsController < Devise::SessionsController
  include WithLocale
  include Users::AddUniversityToRequestParams
end
