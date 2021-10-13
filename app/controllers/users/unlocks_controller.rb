class Users::UnlocksController < Devise::UnlocksController
  include WithLocale
  include Users::AddUniversityToRequestParams
end
