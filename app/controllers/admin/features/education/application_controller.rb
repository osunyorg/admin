class Admin::Features::Education::ApplicationController < Admin::ApplicationController
  def breadcrumb
    super
    add_breadcrumb 'Enseignement'
  end
end
