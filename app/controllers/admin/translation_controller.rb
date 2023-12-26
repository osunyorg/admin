class Admin::TranslationController < Admin::ApplicationController
  def translate
    @target = translation_params[:target]
    @response = LibreTranslate.translate  translation_params[:text],
                                          source: translation_params[:from],
                                          target: translation_params[:to]
  end

  protected

  def translation_params
    params.permit(:text, :from, :to, :target)
  end
end
