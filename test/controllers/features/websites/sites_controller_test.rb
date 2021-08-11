require "test_helper"

class Features::Websites::SitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @features_websites_site = features_websites_sites(:one)
  end

  test "should get index" do
    get features_websites_sites_url
    assert_response :success
  end

  test "should get new" do
    get new_features_websites_site_url
    assert_response :success
  end

  test "should create features_websites_site" do
    assert_difference('Features::Websites::Site.count') do
      post features_websites_sites_url, params: { features_websites_site: { domain: @features_websites_site.domain, name: @features_websites_site.name } }
    end

    assert_redirected_to features_websites_site_url(Features::Websites::Site.last)
  end

  test "should show features_websites_site" do
    get features_websites_site_url(@features_websites_site)
    assert_response :success
  end

  test "should get edit" do
    get edit_features_websites_site_url(@features_websites_site)
    assert_response :success
  end

  test "should update features_websites_site" do
    patch features_websites_site_url(@features_websites_site), params: { features_websites_site: { domain: @features_websites_site.domain, name: @features_websites_site.name } }
    assert_redirected_to features_websites_site_url(@features_websites_site)
  end

  test "should destroy features_websites_site" do
    assert_difference('Features::Websites::Site.count', -1) do
      delete features_websites_site_url(@features_websites_site)
    end

    assert_redirected_to features_websites_sites_url
  end
end
