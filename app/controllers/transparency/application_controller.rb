class Transparency::ApplicationController < ApplicationController
  layout 'transparency/layouts/application'
  skip_before_action :ensure_university, :authenticate_user!
end
