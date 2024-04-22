class Showcase::ApplicationController < ApplicationController
  layout 'showcase/layouts/application'
  skip_before_action :ensure_university, :authenticate_user!
end
