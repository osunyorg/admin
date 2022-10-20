class Users::PasswordsController < Devise::PasswordsController
  include Users::AddContextToRequestParams
  include Users::LayoutChoice

  def update
    super do |resource|
      I18n.locale = resource.language.iso_code.to_sym if resource&.persisted?
    end

    enforce_two_factor_authentication
  end
end
