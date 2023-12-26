class Admin::TranslationController < Admin::ApplicationController
  def translate
    @target = translation_params[:target]
    # @response = LibreTranslate.translate  text: translation_params[:text],
    #                                       from: translation_params[:from],
    #                                       to: translation_params[:to]
    @response = {
      'translatedText' => 'test'
    }
  end

  protected

  def translation_params
    params.permit(:text, :from, :to, :target)
  end
end
