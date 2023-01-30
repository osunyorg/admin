require "test_helper"

class Server::DashboardControllerTest < ActionDispatch::IntegrationTest
  include ServerSetup

  def test_index
    get server_root_path
    assert_response(:success)
  end
end
