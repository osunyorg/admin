module Users::LayoutChoice
  extend ActiveSupport::Concern

  included do
    layout :extranet_or_default
  end

  private

  def extranet_or_default
    # extranet have their custom devise layout
    # university osuny sessions have an "admin" layout for registration edit/update, else default devise layout.
    case current_mode
    when 'extranet'
      'extranet/layouts/devise'
    when 'university'
      (controller_path == 'users/registrations' && ['edit', 'update'].include?(action_name)) ? 'admin/layouts/application' : 'devise'
    end
  end
end
