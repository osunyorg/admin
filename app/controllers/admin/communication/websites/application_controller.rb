class Admin::Communication::Websites::ApplicationController < Admin::Communication::ApplicationController
  load_and_authorize_resource :website,
                              class: Communication::Website,
                              through: :current_university,
                              through_association: :communication_websites

  protected

  def current_website_language
    @current_website_language ||= @website.best_language_for(params[:lang])
  end
  helper_method :current_website_language

  def default_url_options
    options = {}
    if @website.present?
      options[:website_id] = @website.id
      options[:lang] = current_website_language.iso_code
    end
    options
  end
end
