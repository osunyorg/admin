module Admin::HasStaticAction
  extend ActiveSupport::Concern

  def static
    @about = @l10n
    object = @l10n.about
    @website = object.try(:website) || object.try(:websites)&.first
    partial = @about.template_static
    render  partial, 
            layout: false, 
            content_type: "text/plain; charset=utf-8"
  end

end