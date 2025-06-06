module Admin::HasStaticAction
  extend ActiveSupport::Concern

  def static
    @about = @l10n
    @object = @l10n.about
    @website = context_website
    partial = @about.template_static
    render  partial, 
            layout: false, 
            content_type: "text/plain; charset=utf-8"
  end

  protected
  
  def context_website
    website = current_university.communication_websites.find_by(id: params[:context_website_id])
    website ||= @object.try(:website)
    website ||= @object.try(:websites)&.first
    website
  end

end