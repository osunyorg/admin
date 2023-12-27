class Admin::TranslationController < Admin::ApplicationController
  skip_before_action :verify_authenticity_token

  def translate
    @text = translation_params[:text].to_s
    head :ok and return if @text.blank?
    @to = translation_params[:to]
    @response = LibreTranslate.translate  @text,
                                          source: 'auto',
                                          target: @to
    render json: @response
  end

  protected

  def translation_params
    params.permit(:text, :to)
  end
end
