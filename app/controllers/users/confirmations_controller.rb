class Users::ConfirmationsController < Devise::ConfirmationsController
  include Users::AddUniversityToRequestParams
end
