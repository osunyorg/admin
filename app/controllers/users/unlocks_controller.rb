class Users::UnlocksController < Devise::UnlocksController
  include Users::AddUniversityToRequestParams
  include Users::LayoutChoice
end
