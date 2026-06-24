class Transparency::ApplicationController < ApplicationController
  layout 'layouts/public'
  skip_before_action :ensure_university, :authenticate_user!
end
