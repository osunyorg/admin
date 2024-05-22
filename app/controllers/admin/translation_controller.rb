class Admin::TranslationController < Admin::ApplicationController

  def translate
    @text = translation_params[:text].to_s.strip
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

  # TODO check abilities (no visitor should use this)
  def check
    osuny_language_tool = Osuny::LanguageTool.new(
      params[:text],
      params[:language]
    )
    render plain: osuny_language_tool.html_with_suggestions
  end

  protected

  def translation_params
    params.permit(:text, :target)
  end
end
