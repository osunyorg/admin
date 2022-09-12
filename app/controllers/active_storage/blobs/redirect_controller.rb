# frozen_string_literal: true

# Take a signed permanent reference for a blob and turn it into an expiring service URL for download.
# Note: These URLs are publicly accessible. If you need to enforce access protection beyond the
# security-through-obscurity factor of the signed blob references, you'll need to implement your own
# authenticated redirection controller.
class ActiveStorage::Blobs::RedirectController < ActiveStorage::BaseController
  include ActiveStorage::CheckAbilities
  include ActiveStorage::SetBlob

  before_action :check_abilities, only: :show
  skip_before_action :handle_two_factor_authentication

  def show
    expires_in ActiveStorage.service_urls_expire_in
    redirect_to @blob.url(disposition: params[:disposition]), allow_other_host: true
  end

end
