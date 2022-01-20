class Admin::Research::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    if @journal
      short_breadcrumb
      breadcrumb_for @journal
    elsif @laboratory
      short_breadcrumb
      breadcrumb_for @laboratory
    else
      super
      add_breadcrumb Research.model_name.human
    end
  end
end
