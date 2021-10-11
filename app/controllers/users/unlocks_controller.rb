class Users::UnlocksController < Devise::UnlocksController
  include Users::AddUniversityToRequestParams
end
