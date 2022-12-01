module User::WithAdminTheme
  extend ActiveSupport::Concern

  included do
    enum admin_theme: {
      appstack: 0, 
      pure: 1 
    }
  end
end