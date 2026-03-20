class Admin::Communication::ContentsController < Admin::Communication::ApplicationController
  before_action :load_about
  layout false

  # /admin/fr/communication/contents/Communication::Website::Post::Localization/eb500b67-f14e-4085-b449-8a9e68150656/write
  def write
  end

  # /admin/fr/communication/contents/Communication::Website::Post::Localization/eb500b67-f14e-4085-b449-8a9e68150656/structure
  def structure
  end

  def reset
    @about.blocks.destroy_all
    @about.duplicate_blocks_from_original
    redirect_back(
        fallback_location: [:admin, @about],
        notice: t('admin.successfully_updated_html', model: @about.to_s)
      )
  end

  protected

  def load_about
    @about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      mandatory_module: Contentful
    )
    # We check ability on localization's about
    raise_403_unless can?(:update, @about.about)
  end
end