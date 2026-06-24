class Admin::Communication::Blocks::GroupController < Admin::Communication::ApplicationController
  before_action :load_about
  layout false

  def index
    @blocks = @about.blocks.ordered
  end

  def reset
    @about.reset_blocks
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