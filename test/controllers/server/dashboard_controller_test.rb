require "test_helper"

class Server::DashboardControllerTest < ActionDispatch::IntegrationTest
  include ServerSetup

  def test_index
    VCR.use_cassette(location) do
      get server_root_path
      assert_response(:success)
    end
  end
end
