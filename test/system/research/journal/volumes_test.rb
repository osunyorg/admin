require "application_system_test_case"

class Research::Journal::VolumesTest < ApplicationSystemTestCase
  setup do
    @research_journal_volume = research_journal_volumes(:one)
  end

  test "visiting the index" do
    visit research_journal_volumes_url
    assert_selector "h1", text: "Research/Journal/Volumes"
  end

  test "creating a Volume" do
    visit research_journal_volumes_url
    click_on "New Research/Journal/Volume"

    fill_in "Number", with: @research_journal_volume.number
    fill_in "Published at", with: @research_journal_volume.published_at
    fill_in "Title", with: @research_journal_volume.title
    click_on "Create Volume"

    assert_text "Volume was successfully created"
    click_on "Back"
  end

  test "updating a Volume" do
    visit research_journal_volumes_url
    click_on "Edit", match: :first

    fill_in "Number", with: @research_journal_volume.number
    fill_in "Published at", with: @research_journal_volume.published_at
    fill_in "Title", with: @research_journal_volume.title
    click_on "Update Volume"

    assert_text "Volume was successfully updated"
    click_on "Back"
  end

  test "destroying a Volume" do
    visit research_journal_volumes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Volume was successfully destroyed"
  end
end
