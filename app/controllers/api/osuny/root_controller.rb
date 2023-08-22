class Api::Osuny::RootController < Api::ApplicationController
  def index
    @websites = current_university.communication_websites.in_production
  end

  def theme_released
    # TODO check security
    # TODO autoupdate
  end
end
