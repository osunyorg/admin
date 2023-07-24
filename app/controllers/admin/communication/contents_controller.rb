class Admin::Communication::ContentsController < Admin::Communication::ApplicationController
  before_action :load_about
  layout false

  # /admin/communication/contents/Communication::Website::Page/a788f3ab-a3a8-4d26-9440-6cb12fbf442c/write
  def write
  end

  # /admin/communication/contents/Communication::Website::Page/a788f3ab-a3a8-4d26-9440-6cb12fbf442c/structure
  def structure
  end

  protected

  def load_about
    @about = PolymorphicObjectFinder.find(params, :about)
    raise_403_unless @about.university == current_university
    raise_403_unless can?(:edit, @about)
  end
end