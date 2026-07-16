require "test_helper"

class Server::WebsitesForceResyncTest < ActionDispatch::IntegrationTest
  test "renders website show page with the force resync button" do
    sign_in_with_2fa server_admin
    get server_website_path(id: website_with_github.id)
    assert_response :success
    assert_match force_resync_with_git_server_website_path(website_with_github), response.body
  end

  test "force_resync_with_git action marks files and redirects" do
    sign_in_with_2fa server_admin
    git_file = website_with_github.git_files.generated.first
    git_file.update_columns(desynchronized: false, desynchronized_at: nil)

    post force_resync_with_git_server_website_path(website_with_github)

    assert_redirected_to server_website_path(website_with_github)
    assert git_file.reload.desynchronized
  end
end
