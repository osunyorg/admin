module Communication::Website::WithContentArchive
  extend ActiveSupport::Concern

  protected

  def touch_archivable_content
    # TODO
    # Touch les actualités (non pérennes) publiées il y a plus de X ans
    # Touch les événements (non pérennes) terminés il y a plus de X ans
    # Touch les expositions (non pérennes) terminées il y a plus de X ans
  end
end
