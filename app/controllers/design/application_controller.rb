class Design::ApplicationController < ApplicationController
  layout 'design/layouts/application'
  skip_before_action :ensure_university, :authenticate_user!
end
