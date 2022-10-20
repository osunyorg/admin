class Users::UnlocksController < Devise::UnlocksController
  include Users::AddContextToRequestParams
  include Users::LayoutChoice
end
