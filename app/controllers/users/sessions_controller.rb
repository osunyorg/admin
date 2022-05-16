class Users::SessionsController < Devise::SessionsController
  include Users::AddUniversityToRequestParams
end
