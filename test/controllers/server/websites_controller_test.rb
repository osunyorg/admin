require "test_helper"

class Server::WebsitesControllerTest < ActionDispatch::IntegrationTest
  include ServerSetup

  def test_index
    get server_websites_path
    assert_response(:success)
  end

  def test_refresh
    post(refresh_server_website_path(communication_websites(:website_with_github)), xhr: true)
    assert_response(:success)
  end
end
