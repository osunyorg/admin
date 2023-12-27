class Admin::TranslationController < Admin::ApplicationController
  skip_before_action :verify_authenticity_token

  def translate
    @text = translation_params[:text].to_s
    head :ok and return if @text.blank?
    @target = translation_params[:target]
    @response = LibreTranslate.translate(
                  @text, 
                  source: 'auto', 
                  format: 'html',
                  target: @target
                )
    render json: @response
  end

  protected

  def translation_params
    params.permit(:text, :target)
  end
end
