class Admin::TranslationController < Admin::ApplicationController
  skip_before_action :verify_authenticity_token

  def translate
    @target = translation_params[:target]
    @response = LibreTranslate.translate  translation_params[:text],
                                          source: 'auto',
                                          target: translation_params[:to]
    render json: @response
  end

  protected

  def translation_params
    params.permit(:text, :from, :to, :target)
  end
end
