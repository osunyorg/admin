class ApplicationController < ActionController::Base
  include WithDomain
  include WithErrors
  include WithFeatures
  include WithLocale
  include WithMaintenance

  before_action :ensure_university, :authenticate_user!, :load_block_copy_cookie

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end

  private

  def current_ability
    @current_ability ||= Ability.for(current_user)
  end

  def ensure_university
    render_forbidden unless current_university
  end

  def load_block_copy_cookie
    block_id = cookies[Communication::Block::BLOCK_COPY_COOKIE]
    return if block_id.nil?
    @block_copied = current_university.communication_blocks.find block_id
  rescue
    # If the block doesn't exist anymore
  end
end
