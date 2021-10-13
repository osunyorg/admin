class Users::ConfirmationsController < Devise::ConfirmationsController
  include WithLocale
  include Users::AddUniversityToRequestParams
end
