# frozen_string_literal: true

# Take a signed permanent reference for a blob representation and turn it into an expiring service URL for download.
# Note: These URLs are publicly accessible. If you need to enforce access protection beyond the
# security-through-obscurity factor of the signed blob and variation reference, you'll need to implement your own
# authenticated redirection controller.
class ActiveStorage::Representations::RedirectController < ActiveStorage::Representations::BaseController
  include ActiveStorage::CheckAbilities

  before_action :check_abilities, only: :show
  skip_before_action :handle_two_factor_authentication

  def show
    expires_in ActiveStorage.service_urls_expire_in
    redirect_to @representation.url(disposition: params[:disposition])
  end

end
