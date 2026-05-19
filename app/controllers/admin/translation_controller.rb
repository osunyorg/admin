class Admin::TranslationController < Admin::ApplicationController
  def translate
    @text = translation_params[:text].to_s.strip
    head :ok and return if @text.blank?
    @response = LibreTranslate.translate(
                  @text,
                  source: translation_params[:source],
                  target: translation_params[:target],
                  format: 'html'
                )
    render json: @response
  end

  protected

  def translation_params
    params.permit(:text, :source, :target)
  end
end
