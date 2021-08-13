require "test_helper"

class Research::Journal::VolumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @research_journal_volume = research_journal_volumes(:one)
  end

  test "should get index" do
    get research_journal_volumes_url
    assert_response :success
  end

  test "should get new" do
    get new_research_journal_volume_url
    assert_response :success
  end

  test "should create research_journal_volume" do
    assert_difference('Research::Journal::Volume.count') do
      post research_journal_volumes_url, params: { research_journal_volume: { number: @research_journal_volume.number, published_at: @research_journal_volume.published_at, title: @research_journal_volume.title } }
    end

    assert_redirected_to research_journal_volume_url(Research::Journal::Volume.last)
  end

  test "should show research_journal_volume" do
    get research_journal_volume_url(@research_journal_volume)
    assert_response :success
  end

  test "should get edit" do
    get edit_research_journal_volume_url(@research_journal_volume)
    assert_response :success
  end

  test "should update research_journal_volume" do
    patch research_journal_volume_url(@research_journal_volume), params: { research_journal_volume: { number: @research_journal_volume.number, published_at: @research_journal_volume.published_at, title: @research_journal_volume.title } }
    assert_redirected_to research_journal_volume_url(@research_journal_volume)
  end

  test "should destroy research_journal_volume" do
    assert_difference('Research::Journal::Volume.count', -1) do
      delete research_journal_volume_url(@research_journal_volume)
    end

    assert_redirected_to research_journal_volumes_url
  end
end
