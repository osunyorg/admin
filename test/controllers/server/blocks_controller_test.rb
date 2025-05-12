require "test_helper"

class Server::BlocksControllerTest < ActionDispatch::IntegrationTest
  include ServerSetup

  def test_index
    get server_blocks_path
    assert_response(:success)
  end

  def test_show
    get(server_block_path("chapter"))
    assert_response(:success)
  end
end
